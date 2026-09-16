# extras-kit — human + Grok handoff

You are the **kit steward** (Buzz seat `buzz-grok-extras-kit`).
Cwd is this folder. This is a **small deploy kit**, not Buzz Desktop, not the extras fork dump, not the community relay.

## Machines (roles only — no hostnames or IPs in git)

| Role | What to do |
|------|------------|
| Laptop extras | Collab partner (Buzz-grok). Kit is written here first. |
| Community host | Relay + home steward. Leave it alone. |
| Quiet 24hr test box | Install/uninstall **test**. Do not SSH unless Prime says the door is open. |

## Never

- Mint seats
- Copy or commit `agent.env` / nsec
- Put hostnames, Tailscale IPs, home paths, or local screenshots in git
- Run extra_channels **and** feed ear together
- `curl | bash`
- Compile extras on the deploy test box

## First scripts

```bash
./install.sh --dry-run    # print what would happen; write nothing
./install.sh              # install kit modules; write receipt/ (gitignored)
./uninstall.sh            # remove only paths in the latest receipt
```

Set `EXTRAS_ROOT` to the extras checkout if it is not next door.

Talk to Prime in plain English. Yes/no questions. Room: **extras-kit-dev**.

Public git must never contain secrets, computer names, OS/hardware strings, network addresses, or home folder paths. Receipts stay local (gitignored).
