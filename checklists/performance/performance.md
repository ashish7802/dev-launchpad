# ⚡ Performance Optimization Checklist

Comprehensive performance review covering both frontend and backend systems.

---

## 🎨 Frontend — Loading Performance

- [ ] **Core Web Vitals meet targets**
  &gt; LCP &lt; 2.5s, FID/INP &lt; 200ms, CLS &lt; 0.1. Verified in CrUX or field data, not just lab tests.

- [ ] **Critical CSS inlined, non-critical CSS deferred**
  &gt; Above-the-fold styles in `&lt;head&gt;`. Remaining CSS loaded asynchronously or via `media="print"` swap.

- [ ] **JavaScript bundles split and lazy-loaded**
  &gt; Route-based code splitting. Dynamic imports for below-fold components. Vendor chunk cached separately.

- [ ] **Images optimized and responsive**
  &gt; WebP/AVIF with fallbacks. `srcset` for density switching. Lazy loading for off-screen images.

- [ ] **Fonts loaded with `font-display: swap`**
  &gt; No invisible text during load. Subset fonts to used characters. Preload critical font files.

---

## 🎨 Frontend — Runtime Performance

- [ ] **No layout thrashing (forced synchronous layout)**
  &gt; Batch DOM reads and writes. Use `requestAnimationFrame` for visual updates. Avoid reading `offsetHeight` in loops.

- [ ] **Event handlers debounced or throttled**
  &gt; Scroll, resize, and input handlers rate-limited. Passive event listeners where appropriate.

- [ ] **Memory leaks prevented**
  &gt; Event listeners removed on unmount. Intervals and timeouts cleared. Large objects nulled for GC.

- [ ] **Animations use `transform` and `opacity` only**
  &gt; Composite-only properties for 60fps. Avoid animating `width`, `height`, `top`, `left`.

- [ ] **Web Workers used for heavy computation**
  &gt; Image processing, data parsing, and encryption off main thread. Service Worker caches assets.

---

## 🎨 Frontend — Network Efficiency

- [ ] **HTTP/2 or HTTP/3 enabled**
  &gt; Server push used judiciously. Multiplexing reduces connection overhead.

- [ ] **Resources compressed (Brotli preferred, Gzip fallback)**
  &gt; Text assets compressed at level 11. Precompressed static files served directly.

- [ ] **Caching headers configured optimally**
  &gt; Immutable assets cached 1 year. HTML cached briefly or revalidated. Cache busting via filename hashing.

- [ ] **Third-party scripts loaded asynchronously or deferred**
  &gt; Analytics, ads, and widgets don't block rendering. Preconnect to critical third-party origins.

- [ ] **CDN used for static assets**
  &gt; Geographic distribution reduces latency. Edge caching for API responses where appropriate.

---

## ⚙️ Backend — Response Time

- [ ] **API p50 &lt; 100ms, p99 &lt; 500ms**
  &gt; Percentile targets defined and monitored. Latency budgets allocated per endpoint.

- [ ] **Database queries execute in &lt; 50ms**
  &gt; Query plans reviewed. Slow query log monitored. N+1 queries eliminated via joins or data loader.

- [ ] **Caching strategy reduces database load**
  &gt; Redis/Memcached for hot data. Cache-aside or write-through pattern. TTLs tuned to data freshness needs.

- [ ] **External API calls parallelized and cached**
  &gt; `Promise.all()` for independent requests. Circuit breakers prevent cascade failures. Response caching where idempotent.

- [ ] **JSON serialization optimized**
  &gt; Avoid nested serialization. Use streaming JSON for large responses. Exclude unused fields.

---

## ⚙️ Backend — Throughput & Scalability

- [ ] **Connection pooling configured**
  &gt; Database, HTTP, and cache connections pooled. Pool size matches worker/thread count. Timeout handling robust.

- [ ] **Horizontal scaling stateless**
  &gt; No session affinity required. Shared-nothing architecture. Load balancer health checks functional.

- [ ] **Queue-based processing for background jobs**
  &gt; Email, reports, and imports async via Celery, Sidekiq, or Bull. Queue depth monitored.

- [ ] **Auto-scaling triggers calibrated**
  &gt; Scale out before saturation. Scale in conservatively. Cooldown periods prevent thrashing.

- [ ] **Rate limiting prevents abuse**
  &gt; Per-user and per-IP limits. 429 responses with Retry-After headers. Distributed rate limiting if clustered.

---

## ⚙️ Backend — Resource Efficiency

- [ ] **Memory usage stable (no leaks or unbounded growth)**
  &gt; Heap profiles reviewed. Objects released after use. No accumulation in global caches.

- [ ] **CPU-intensive operations optimized**
  &gt; Algorithmic complexity minimized. Hot paths profiled. Caching of computed results.

- [ ] **Database indexes support query patterns**
  &gt; Composite indexes match filter order. Covering indexes for common queries. Index bloat monitored.

- [ ] **Pagination for large result sets**
  &gt; Cursor-based for stability, offset for simple cases. Maximum page size enforced. No unbounded `SELECT *`.

- [ ] **File I/O streaming for large payloads**
  &gt; No loading multi-MB files into memory. Streams piped efficiently. Backpressure handled.

---

## 🗄️ Database Performance

- [ ] **Query execution plans reviewed for new queries**
  &gt; `EXPLAIN ANALYZE` run in production-like conditions. Sequential scans on large tables justified.

- [ ] **Appropriate data types and constraints**
  &gt; `UUID` vs `BIGINT` chosen intentionally. `VARCHAR` lengths reasonable. Foreign keys indexed.

- [ ] **Partitioning or sharding for large tables**
  &gt; Time-based partitioning for logs/events. Hash sharding when single-node limits approached.

- [ ] **Vacuum/analyze maintenance scheduled**
  &gt; Autovacuum tuned for write-heavy tables. Manual vacuum after bulk operations. Statistics updated.

- [ ] **Read replicas used for read-heavy workloads**
  &gt; Replication lag monitored. Stale reads acceptable for use case. Failover tested.

---

## 📊 Monitoring & Validation

- [ ] **Real User Monitoring (RUM) implemented**
  &gt; Field data captures actual user experience. Geographic and device segmentation.

- [ ] **Synthetic monitoring checks critical paths**
  &gt; Pingdom, GTmetrix, or custom probes test login, checkout, and search every few minutes.

- [ ] **Performance budgets enforced in CI**
  &gt; Bundle size limits fail builds. Lighthouse score thresholds gate deployment.

- [ ] **Load testing validates capacity claims**
  &gt; k6, Artillery, or Locust simulate peak traffic. Bottlenecks identified before production.

- [ ] **Profiling tools used for deep dives**
  &gt; Chrome DevTools Performance tab, Node.js `--prof`, Python cProfile, Go pprof. Flame graphs analyzed.

**Performance Owner:** _______________ **Test Date:** _______________ **Target SLA:** _______________
