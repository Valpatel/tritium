# Tritium Replication Manifest

Host inventory and replication status for disaster recovery.
Last updated: 2026-03-14 (Wave 59).

## Host Inventory

| Host | Role | Location | Network | Status | Can Build | Can Test |
|------|------|----------|---------|--------|-----------|---------|
| gb10-01 | Primary dev | ~/Code/tritium | Tailscale 100.93.184.1 | Active | Yes | Yes |
| gb10-02 | Backup dev | ~/Code/tritium | DNS unreachable | Offline | Unknown | Unknown |
| GitHub | Remote origin | Valpatel/tritium | github.com | Pushed | N/A | CI |
| eng-mvalancy-macmini | macOS workstation | — | Tailscale 100.98.72.95 | Idle | Unknown | Unknown |
| mv-yoga | Linux laptop | — | Tailscale 100.83.248.77 | Offline (1d) | Unknown | Unknown |
| vps-1 | VPS gateway | — | Tailscale 100.79.60.48 | Active | No (no GPU) | Partial |

## Primary Host Details (gb10-01)

- **OS**: Linux 6.17.0-1008-nvidia
- **RAM**: 122 GB total, ~74 GB available
- **Disk**: 916 GB total, 97 GB free (89% used)
- **Python**: 3.12+
- **Submodules**: tritium-edge, tritium-sc, tritium-lib (all on dev branch)
- **Test baselines**: lib=833, sc=7666+, edge=0 warnings

## Replication Status

### gb10-02
- **Status**: DNS resolution fails as of 2026-03-14
- **Action needed**: Verify hostname/network config, re-attempt sync
- **Last known sync**: Unknown

### GitHub (Valpatel/tritium)
- **Status**: Active, all submodules pushed to dev
- **Includes**: tritium (parent), tritium-sc, tritium-edge, tritium-lib
- **Recovery**: `git clone --recurse-submodules git@github.com:Valpatel/tritium.git`

## Recovery Instructions

### From GitHub (any Linux host with Python 3.12+)

```bash
# 1. Clone with submodules
git clone --recurse-submodules git@github.com:Valpatel/tritium.git
cd tritium

# 2. Checkout dev branch everywhere
git checkout dev
git submodule foreach 'git checkout dev'

# 3. Set up tritium-lib
cd tritium-lib
python3 -m venv .venv
source .venv/bin/activate
pip install -e ".[full]"
pytest tests/ -q  # Verify

# 4. Set up tritium-sc
cd ../tritium-sc
./setup.sh dev
./test.sh fast  # Verify

# 5. Set up tritium-edge (requires PlatformIO)
cd ../tritium-edge
pip install platformio
pio run -e touch-lcd-43c-box-os  # Verify build
```

### From Backup Host via SSH

```bash
# If gb10-02 becomes reachable:
ssh gb10-02 "cd ~/Code && git clone --recurse-submodules git@github.com:Valpatel/tritium.git 2>/dev/null || (cd tritium && git pull --recurse-submodules)"
ssh gb10-02 "cd ~/Code/tritium/tritium-lib && pip install -e . && python3 -m pytest tests/ -q --timeout=60"
```

## Monitoring

Check replication health:
```bash
# Local resources
free -m && df -h /home/scubasonar

# Tailscale peers
tailscale status

# Attempt gb10-02
ssh -o ConnectTimeout=3 gb10-02 "hostname && df -h /home/" 2>/dev/null

# Git remote status
git remote -v && git submodule foreach 'git remote -v'
```

## Notes

- gb10-02 hostname resolution failure may be a Tailscale DNS issue (health check shows DNS warning)
- Disk usage on gb10-01 is at 89% — consider cleanup of .pio build caches
- AGPL-3.0 license: code is designed to be shared and replicated freely
