# 🔒 Web Application Security Checklist

Comprehensive security review for web applications before production release or audit.

---

## 🔐 Authentication

- [ ] **Passwords require minimum complexity (12+ chars, mixed case, numbers, symbols)**
  &gt; Enforce strong passwords. Reject common passwords against breach databases like Have I Been Pwned.

- [ ] **Multi-factor authentication (MFA) available for sensitive accounts**
  &gt; TOTP or WebAuthn for admin, finance, and privileged roles. SMS as fallback only if necessary.

- [ ] **Session tokens are cryptographically random and sufficiently long**
  &gt; 128+ bits entropy. Generated via CSPRNG. Not predictable from user data.

- [ ] **Sessions expire and require re-authentication for sensitive actions**
  &gt; Idle timeout (15-30 min), absolute timeout (8-24 hours). Re-auth for password change, email change, or high-value transactions.

- [ ] **Failed login attempts are rate-limited and logged**
  &gt; Exponential backoff after failures. Account lockout with email notification. No user enumeration via error messages.

---

## 🛡️ Authorization

- [ ] **Principle of least privilege enforced**
  &gt; Users have minimum necessary permissions. Roles are granular and composable.

- [ ] **Resource access verified on every request**
  &gt; Server-side authorization checks for all endpoints. No reliance on client-side hiding.

- [ ] **IDOR vulnerabilities prevented**
  &gt; UUIDs or hashed identifiers instead of sequential integers. Access control checks on object-level operations.

- [ ] **Admin interfaces restricted by IP or VPN**
  &gt; Admin panels not publicly accessible. Additional authentication layer required.

---

## 🌐 Input Validation & Injection Prevention

- [ ] **All user inputs validated for type, length, format, and range**
  &gt; Whitelist validation on server side. Reject, don't sanitize, malformed input.

- [ ] **SQL/NoSQL queries use parameterized statements**
  &gt; No string concatenation in queries. ORM used consistently. Stored procedures parameterized.

- [ ] **Command injection prevented**
  &gt; No shell execution with user input. `exec()` avoided. Use libraries for file operations.

- [ ] **XSS prevented via output encoding**
  &gt; Context-aware encoding (HTML, JavaScript, CSS, URL). Content Security Policy headers implemented.

- [ ] **File uploads restricted by type, size, and content**
  &gt; Verify MIME type and magic bytes. Store outside web root. Scan with antivirus. Rename to prevent execution.

---

## 🔑 Secrets Management

- [ ] **No secrets committed to version control**
  &gt; Pre-commit hooks scan for API keys, passwords, and private keys. `.env` files in `.gitignore`.

- [ ] **Secrets stored in dedicated vault or KMS**
  &gt; HashiCorp Vault, AWS Secrets Manager, or Azure Key Vault. No environment variables for high-value secrets.

- [ ] **Database credentials rotated regularly**
  &gt; Automated rotation every 90 days or on personnel changes. Unique credentials per service.

- [ ] **API keys scoped and revocable**
  &gt; Fine-grained permissions per key. Expiration dates set. Revocation endpoint functional.

---

## 🛡️ Infrastructure & Network

- [ ] **TLS 1.2+ enforced for all connections**
  &gt; HSTS header with preload. Weak ciphers disabled. Certificate pinning for mobile apps.

- [ ] **Security headers configured**
  &gt; `Content-Security-Policy`, `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Referrer-Policy` set.

- [ ] **CORS policy restrictive and explicit**
  &gt; No wildcard origins in production. Credentials flag consistent. Preflight handling correct.

- [ ] **DDoS protection and WAF enabled**
  &gt; Cloudflare, AWS Shield, or equivalent. Rate limiting per IP and per user. Geographic blocking if applicable.

- [ ] **Container images scanned for vulnerabilities**
  &gt; Trivy, Snyk, or Clair integrated in CI. Base images minimal (distroless or alpine). No running as root.

---

## 📊 Logging & Monitoring

- [ ] **Security events logged with context**
  &gt; Login attempts, permission changes, data exports, and admin actions logged with timestamp, IP, and user agent.

- [ ] **Logs immutable and centrally aggregated**
  &gt; Write-once storage. Tamper-evident. Retained for compliance period (typically 1-7 years).

- [ ] **PII redacted or tokenized in logs**
  &gt; No passwords, tokens, credit cards, or health data in plaintext logs. Structured logging with field-level encryption.

- [ ] **Anomaly detection alerts configured**
  &gt; Unusual login locations, off-hours access, bulk downloads, or privilege escalation trigger alerts.

---

## 🧪 Security Testing

- [ ] **Dependency vulnerabilities scanned (SAST/SCA)**
  &gt; Snyk, OWASP Dependency-Check, or GitHub Advanced Security. Critical/high severity issues resolved.

- [ ] **Dynamic application security testing (DAST) performed**
  &gt; OWASP ZAP or Burp Suite scans. No high/critical findings unremediated.

- [ ] **Penetration testing completed for major releases**
  &gt; External firm or internal red team. Findings tracked to resolution.

- [ ] **Security unit tests for auth and authorization**
  &gt; Automated tests verify unauthorized access is blocked. Role-based access control tested.

---

## 📋 Compliance & Data

- [ ] **Data classification implemented**
  &gt; Public, internal, confidential, restricted labels applied. Handling requirements enforced.

- [ ] **Encryption at rest for sensitive data**
  &gt; AES-256 for databases, files, and backups. Key rotation policy documented.

- [ ] **Right to deletion and data portability supported**
  &gt; GDPR/CCPA compliance. Automated data export and erasure workflows tested.

- [ ] **Privacy policy and terms of service current**
  &gt; Legal review completed. Cookie consent implemented. Tracking disclosures accurate.

**Security Lead:** _______________ **Review Date:** _______________ **Next Review:** _______________  
