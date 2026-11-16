# CSC 579 — Evaluating IoT/Edge Linux Distributions

This repository contains a static project website (`site/`), bi-weekly updates (`site/docs/`), progress logbook (`logbook/`), shell scripts (`scripts/`), and raw results (`results/`).

**Evidence boundary:** Debian guest installation verified from student screenshot. Shell scripts smoke-tested in a separate Linux environment; Debian VM benchmarks and reboot tests still pending.

## Debian guest commands
```bash
cd ~/CSC579_Project_Ready
sh scripts/test_harness.sh
sh scripts/edge_probe.sh debian results/debian
sudo reboot
# After restart, from the same directory:
sh scripts/verify_persistence.sh results/debian
```
The smoke test uses temporary files and deliberately tampers with *a temporary test payload*, not user files.

## Netlify configuration
Connect repository to Netlify, set base directory to repository root, build command blank, and publish directory `site`.

## Publication
Report only measured results; do not describe a clean-reboot check as abrupt-shutdown resilience.
