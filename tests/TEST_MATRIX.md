# Suricata Test Matrix
| ID | Test | Expected outcome | Actual outcome | Evidence | Status |
|---|---|---|---|---|---|
| T01 | ICMP alert | Intended custom rule matches assigned test | Not run | | Not started |
| T02 | HTTP alert | Intended custom rule matches assigned test | Not run | | Not started |
| T03 | UDP alert | Intended custom rule matches assigned test | Not run | | Not started |
| T04 | SSH alert | Intended custom rule matches assigned test | Not run | | Not started |
| T05 | DNS alert | Intended custom rule matches assigned test | Not run | | Not started |
| T06 | `fast.log` review | Relevant alert summary present if enabled/expected | Not run | | Not started |
| T07 | `eve.json` review | Relevant structured event present if enabled/expected | Not run | | Not started |

Statuses: `Not started`, `In progress`, `Passed`, `Failed`, `Blocked`. Explain blocked tests. Alerts may be absent if traffic is not visible, rules are not loaded/matched, or logging is disabled.
