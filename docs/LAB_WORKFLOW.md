# Suricata Lab Workflow — Screenshot-Based Version

This file replaces `docs/LAB_WORKFLOW.md` in the Suricata Practical Lab Workflow repository. It follows the sequence and visible commands/configuration from the screenshots in `Suricata_Lab.docx`.

> **Lab context shown in the screenshots:** Suricata on the monitoring workstation, network interface `enp0s3`, and the target/Home Network IP `192.168.1.106`. Confirm your own interface, IP address, and paths before running commands; these values may differ in your environment.

## 1. Install Suricata

Check whether Suricata is already installed:

```bash
suricata -V
```

If the command is missing on Ubuntu/Debian, install it:

```bash
sudo apt update
sudo apt install suricata
```

Then verify the installation and inspect the available options:

```bash
suricata -V
suricata --help
```

Record the version shown in your own terminal.

## 2. Identify the network interface and IP address

On the Suricata monitoring workstation, list interfaces and addresses:

```bash
ip addr
# or
ifconfig
```

The screenshots show interface `enp0s3` and a workstation address of `192.168.1.105`. The later configuration and Kali tests use `192.168.1.106` as the Suricata host/Home Network address. Confirm which address belongs to each VM in your own lab before continuing.

## 3. Back up `suricata.yaml`

The screenshots back up the configuration file and then list the backup to verify that it exists:

```bash
sudo cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.backup
ls -l /etc/suricata/suricata.yaml*
```

Check that the backup file is listed before editing. If your configuration lives elsewhere, use its actual path.

## 4. Configure `suricata.yaml`

Open the configuration file:

```bash
sudo nano /etc/suricata/suricata.yaml
```

Make the settings required by the lab. The screenshots show these values:

### Home network

Under `vars` / `address-groups`, set the `HOME_NET` value to the Suricata lab host/network address shown in your environment. The screenshot shows:

```yaml
HOME_NET: "[192.168.1.106]"
```

Keep the YAML indentation and syntax consistent with the existing file. Do not copy this IP blindly if your VM uses a different address.

### Network interface (`af-packet`)

The screenshot shows:

```yaml
af-packet:
  - interface: enp0s3
```

Use the interface that actually receives the test traffic on your Suricata VM.

### Default rule path and rule file

The screenshots show:

```yaml
default-rule-path: /var/lib/suricata/rules
rule-files:
  - suricata.rules
```

Your custom rules file must also be loaded by the active configuration. Confirm the correct rule path and rule-file entries for your installed Suricata setup rather than assuming the screenshot paths exist unchanged.

Save in Nano with **Ctrl+O**, press **Enter**, then exit with **Ctrl+X**.

## 5. Update the Suricata rules

The screenshots show running:

```bash
sudo suricata-update
```

Wait for it to finish and review the output for errors. The captured output shows Suricata updating distribution rules and writing `suricata.rules`. This updates the managed rules; it does not replace the need to configure and validate your own custom rules.

## 6. Create custom rules in `local.rules`

Open the local rules file used by your installation. The screenshots show the rules being edited in a local rules file:

```bash
sudo nano /etc/suricata/rules/local.rules
```

The screenshots show these five rule patterns. Use them as a record of the lab's examples and confirm that the active configuration loads this file.

```text
alert icmp any any -> any any (msg:"LAB - ICMP PACKET DETECTED"; sid:1000001; rev:1;)
alert tcp any any -> any 80 (msg:"LAB - HTTP TRAFFIC DETECTED"; sid:1000002; rev:1;)
alert udp any any -> any any (msg:"LAB - UDP PACKET DETECTED"; sid:1000003; rev:1;)
alert tcp any any -> any 22 (msg:"LAB - SSH TRAFFIC DETECTED"; sid:1000004; rev:1;)
alert udp any any -> any 53 (msg:"LAB - DNS TRAFFIC DETECTED"; sid:1000005; rev:1;)
```

These are broad training rules, especially the UDP rule that matches all UDP traffic. Use them only within the authorized lab and follow your instructor's requirements. For real environments, narrow rules to the intended hosts and traffic.

Save and exit Nano. Verify that the rules file is included by the configuration and that the rules are syntactically valid.

## 7. Test the configuration

The screenshots show a configuration test similar to:

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml
```

Use your actual configuration path. Review the complete output and make sure the configuration and rules load without errors before restarting the service. If validation fails, fix the reported issue and run the test again.

## 8. Restart Suricata and check its status

The screenshots show restarting the service and checking its status:

```bash
sudo systemctl restart suricata
sudo systemctl status suricata
```

Confirm that the service is active and check the status output for errors. If the service fails, inspect its error message and logs before proceeding.

## 9. Trigger the five protocol tests from Kali Linux

Run these tests only between the VMs in your own lab or on systems you are explicitly authorized to test. The examples use `192.168.1.106` because that is the Suricata host shown in the screenshots; substitute the correct lab IP if needed.

### A. ICMP

From Kali, send ping packets:

```bash
ping -c 5 192.168.1.106
```

The screenshot shows five replies from `192.168.1.106`. Check whether the custom ICMP alert appears on the Suricata workstation.

### B. HTTP

From Kali, request a web page:

```bash
curl http://example.com
```

The screenshot shows `curl http://example.com`. Check whether the HTTP rule triggers in your Suricata lab. The rule shown matches TCP traffic to destination port 80; HTTPS on port 443 would not match that specific rule.

### C. UDP

The screenshot shows sending a UDP message to port `9999`:

```bash
nc -u 192.168.1.106 9999
```

Type a test message such as:

```text
Hello Suricata
```

Use the method specified by your lab guide to end the `nc` session. Check for the UDP alert on the monitoring workstation.

### D. SSH

The screenshot shows connecting from Kali to the Suricata host with SSH:

```bash
ssh analyst@192.168.1.106
```

Use the correct lab username. If this is the first connection, verify the host fingerprint according to your lab procedure before accepting it. Check whether the SSH alert is generated. The custom rule shown matches TCP destination port 22.

### E. DNS

The screenshot shows a DNS query from Kali:

```bash
dig example.com
```

Review the query result and check whether the DNS rule triggers. The example custom rule matches UDP destination port 53; DNS carried over TCP would not match that rule.

For each test, record the expected result and what actually happened. A command completing successfully does not, by itself, prove that Suricata generated an alert.

## 10. Review `fast.log` and `eve.json`

On the Suricata monitoring workstation, inspect the alert log if enabled:

```bash
sudo tail -f /var/log/suricata/fast.log
```

The screenshots specifically show following `eve.json` and formatting its JSON output with `jq`:

```bash
sudo tail -f /var/log/suricata/eve.json | jq
```

Press **Ctrl+C** to stop following the file. If `jq` is not installed, install it using your distribution's package manager or inspect the raw JSON. Confirm the log paths in your own configuration; paths and logging settings can vary.

Compare what each file shows:
- **`fast.log`**: human-readable alert summaries, when enabled.
- **`eve.json`**: structured JSON events, which can include alert and other event types depending on configuration.

Look for the rule message/SID, timestamp, protocol, source/destination details, and event type. Record only relevant, sanitized details in your project.

## 11. Document and verify the results

Complete `tests/TEST_MATRIX.md` for ICMP, HTTP, UDP, SSH, DNS, and log review. In `results/RESULTS_TEMPLATE.md`, record:
- The command or action used for each test.
- The expected and observed result.
- Whether the alert appeared in `fast.log`, `eve.json`, both, or neither.
- Any errors, missing alerts, and how you investigated them.
- The evidence filenames that support each conclusion.

Save genuine screenshots in `evidence/`. Do not mark tests as passed unless the actual output supports the result.

## 12. Clean up

Review any temporary configuration changes and test artifacts. Keep the backup until you are sure the lab configuration is correct. Restore the backup only if needed and according to your lab instructions. Before pushing to GitHub, remove or redact credentials, sensitive network details, and unapproved logs or packet captures.

---

## Screenshot-to-step reference

This workflow follows the document's visible sequence: installation and version check; interface/IP identification; configuration backup; `HOME_NET`, `af-packet`, and rule-path settings; `suricata-update`; custom `local.rules`; configuration validation; service restart/status; Kali ICMP, HTTP, UDP, SSH, and DNS tests; then review of `fast.log` and `eve.json` with `jq`.
