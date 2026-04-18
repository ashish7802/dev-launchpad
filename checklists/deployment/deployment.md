# 🚀 Deployment Checklist

Complete all sections before, during, and after any production deployment.

---

## 📋 Pre-Deployment (Day Before)

- [ ] **Deployment window communicated to stakeholders**
  &gt; Notify support, customer success, and dependent teams. Post in #deployments or equivalent.

- [ ] **Database migrations reviewed for locking behavior**
  &gt; Long-running migrations scheduled during low traffic. Index creation uses `CONCURRENTLY` if supported.

- [ ] **Feature flags configured for gradual rollout**
  &gt; New features hidden behind flags. Kill switch ready if issues arise.

- [ ] **Rollback plan documented and tested**
  &gt; Previous release artifact is ready. Database rollback scripts prepared if migrations are irreversible.

- [ ] **Monitoring dashboards and alerts verified**
  &gt; Key metrics baselined. Alert thresholds appropriate. On-call engineer aware.

---

## 🔍 Pre-Deployment (1 Hour Before)

- [ ] **CI/CD pipeline is green on main branch**
  &gt; All tests, security scans, and build steps pass. No flaky failures ignored.

- [ ] **Changelog and release notes prepared**
  &gt; User-facing changes documented. Support team briefed on new features and known issues.

- [ ] **Database backups completed and verified**
  &gt; Automated backup confirmed. Point-in-time recovery tested recently.

- [ ] **Secrets and environment variables validated**
  &gt; New env vars added to all environments. No placeholder values in production configs.

- [ ] **Dependency versions pinned and audited**
  &gt; No floating versions. `package-lock.json`, `Cargo.lock`, etc. committed and reviewed.

---

## ⚡ During Deployment

- [ ] **Deploy to staging/canary first**
  &gt; Smoke tests pass in staging. Canary receives &lt; 5% traffic initially.

- [ ] **Database migrations run before app deployment**
  &gt; Backward-compatible migrations first. App code handles old and new schema during transition.

- [ ] **Health checks pass before traffic routing**
  &gt; `/health`, `/ready`, and custom probes return 200. No crash loops.

- [ ] **Traffic shifted gradually (blue-green or canary)**
  &gt; Monitor error rates and latency at each traffic percentage. Auto-rollback triggers configured.

- [ ] **Real-time metrics monitored during rollout**
  &gt; Watch CPU, memory, response times, error rates, and queue depths. SRE on standby.

---

## ✅ Post-Deployment (Immediate)

- [ ] **Smoke tests pass in production**
  &gt; Critical user journeys verified: login, checkout, key API endpoints.

- [ ] **Error rates and latency within normal parameters**
  &gt; Compare to pre-deployment baseline. No spike in 4xx/5xx or P99 latency.

- [ ] **Database performance normal**
  &gt; No slow query log spikes. Connection pools stable. Replication lag acceptable.

- [ ] **External integrations functioning**
  &gt; Payment processors, email services, CDNs, and third-party APIs responding normally.

- [ ] **Customer-facing features verified manually**
  &gt; UI renders correctly. New features accessible. No console errors.

---

## 📊 Post-Deployment (24 Hours)

- [ ] **Error budgets not exceeded**
  &gt; SLO compliance maintained. No alert fatigue from false positives.

- [ ] **Performance metrics stable**
  &gt; No memory leaks, CPU creep, or gradual latency increase.

- [ ] **User feedback channels monitored**
  &gt; Support tickets, social media, and error reporting tools checked for new issues.

- [ ] **Feature flags evaluated for full rollout**
  &gt; Canary metrics positive. Ready to increase traffic or enable globally.

- [ ] **Incident retrospective scheduled if issues occurred**
  &gt; Blameless postmortem within 48 hours. Action items tracked.

---

## 🔄 Rollback Triggers

Abort deployment and rollback if any of the following occur:

- [ ] Error rate increases &gt; 0.1% above baseline
- [ ] P99 latency increases &gt; 50% for &gt; 5 minutes
- [ ] Any critical alert fires (database, payments, auth)
- [ ] Customer-facing feature completely broken
- [ ] Data integrity issues detected

**Deployer:** _______________ **Version:** _______________ **Date:** _______________
