# Tritium Rule Types — Redundancy Analysis

Three rule types exist in the codebase with overlapping patterns. This document clarifies their distinct purposes and when to use each.

## Summary

| Rule Type | Location | Purpose | Executes Actions? | Routes Notifications? |
|-----------|----------|---------|--------------------|-----------------------|
| **AutomationRule** | `tritium-sc/plugins/automation/rules.py` | If-then automation engine | Yes (6 action types) | No (actions can trigger alerts) |
| **AlertRule** | `tritium-lib/models/alert_rules.py` | Event-to-alert generation | No | Yes (via channels) |
| **NotificationRule** | `tritium-lib/models/notification_rules.py` | Notification routing/filtering | No | Yes (delivery routing) |

## Detailed Comparison

### AutomationRule (tritium-sc)

**Purpose:** General-purpose automation. When an event matches a trigger pattern and conditions pass, execute one or more actions.

**Key characteristics:**
- Lives in tritium-sc only (not in shared lib) because it needs access to EventBus, MQTT bridge, and target tracker for action execution
- Uses `TriggerCondition` with string operators ("eq", "neq", "gt", etc.) and dot-notation field access
- 6 action types: `alert`, `command`, `tag`, `escalate`, `notify`, `log`
- `RuleEngine` class manages rules and dispatches actions via registered executors
- Trigger patterns support glob matching (`ble:*`, `geofence:enter`)
- Runtime state (`_last_fired`, `_fire_count`) tracked in-memory

**When to use:** When you want something to *happen* in response to an event (send a command to a device, change a threat level, tag a target).

### AlertRule (tritium-lib)

**Purpose:** Generate alerts from system events. Evaluates event data against conditions and produces alerts routed to notification channels.

**Key characteristics:**
- Lives in tritium-lib (shared between SC and fleet server)
- Uses `AlertCondition` with `ConditionOperator` enum (10 operators including regex, in-list)
- `AlertTrigger` enum defines 16 trigger event types (target_new, device_offline, geofence_breach, etc.)
- Zone and target alliance filters for scoping rules
- Message template with placeholder rendering
- Imports `NotificationChannel` and `NotificationSeverity` from notification_rules
- 5 default rules provided out of the box

**When to use:** When you want to *generate an alert* (notification with severity) from a specific system event. AlertRule is the bridge between events and notifications.

### NotificationRule (tritium-lib)

**Purpose:** Route notifications to delivery channels. Controls which events generate notifications, the minimum severity threshold, and which channels receive them.

**Key characteristics:**
- Lives in tritium-lib (shared)
- Simpler than AlertRule — matches on event type string and severity threshold
- Wildcard trigger (`*`) matches all events
- `NotificationSeverity` enum with rank comparison operators
- Device filter for scoping to specific edge devices
- 4 default rules provided (critical-all-channels, node-offline, battery-low, new-target)

**When to use:** When you want to control *where* notifications go and set minimum severity thresholds. NotificationRule is the delivery configuration layer.

## Data Flow

```
System Event
    |
    v
AutomationRule (SC)  -->  Execute action (command, tag, escalate)
    |                      ^-- may also fire an "alert" action
    v
AlertRule (lib)      -->  Generate alert with severity + message
    |
    v
NotificationRule (lib) --> Route to channels (WebSocket, MQTT, email, webhook, log)
```

## Shared Patterns

All three share these structural elements:
- `rule_id`, `name`, `enabled` fields
- `cooldown_seconds` with `is_cooled_down()` method
- `fire_count`, `last_fired_at` tracking
- `to_dict()` / `from_dict()` serialization
- Condition evaluation with operator-based comparison

## Should They Share a Base?

**Current assessment:** No, not yet. While there is structural similarity, the three types serve genuinely different purposes in the pipeline:

1. **AutomationRule** is an *action executor* — it does things in response to events
2. **AlertRule** is an *alert generator* — it creates notification payloads from events
3. **NotificationRule** is a *delivery router* — it decides where notifications go

A shared `BaseRule` would need to be very thin (just `rule_id`, `enabled`, `cooldown`, `fire_count`) and might not provide enough value to justify the coupling between SC-specific automation logic and shared-lib notification models.

**Future consideration:** If a 4th rule type emerges, or if AlertRule and NotificationRule are used together frequently enough, extract a `BaseRule` dataclass in tritium-lib with the shared fields. AutomationRule in tritium-sc could also inherit from it if tritium-sc depends on tritium-lib (which it does).
