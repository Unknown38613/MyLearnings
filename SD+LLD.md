Here's the complete filtered prep plan.

## System Design — What's actually asked

**Problems (know these)**

1. URL Shortener
2. Instagram / Twitter Feed (News Feed)
3. WhatsApp / Chat System
4. YouTube / Netflix (Video Streaming)
5. Uber / Ride Sharing
6. Notification System
7. Rate Limiter
8. Search Autocomplete

That's it. These 8 cover 90% of what product companies ask.

---

## Concepts — Only what these 8 problems actually need

Don't study concepts in isolation. Here's the map:

| Concept | Which problems need it |
|---|---|
| Caching (Redis) | Every single one |
| Load Balancer | Every single one |
| SQL vs NoSQL | URL shortener, Feed, Chat |
| CDN | YouTube, Instagram |
| Message Queue (Kafka) | Feed, Notifications, Chat |
| WebSockets | Chat, Uber |
| Consistent Hashing | URL shortener, any sharded DB |
| Database Sharding | Feed, YouTube, Chat |
| Blob Storage (S3) | YouTube, Instagram |
| API Gateway | Rate limiter, Uber |

Study a concept *when a problem needs it*, not before. This kills the prerequisite spiral.

---

## LLD — What's actually asked

**Problems (know these)**

1. Parking Lot
2. BookMyShow
3. Splitwise
4. Uber / Ride Sharing
5. Hotel Management
6. Snake and Ladder / Chess
7. Elevator System

**Patterns (only these)**

- Strategy
- Observer
- Factory
- Singleton (surface level)

**SOLID (only these two in practice)**

- Single Responsibility
- Open/Closed

---

## The complete timeline (8 weeks)

**Week 1 — Foundations only**

- SOLID with one example each (2 days)
- Strategy + Observer patterns with one example each (2 days)
- Capacity estimation formula + practice on 3 problems (1 day)
- Factory + Singleton (1 day)

**Week 2–3 — LLD problems**

One problem every 2 days:
- Parking Lot → Elevator → Splitwise → BookMyShow → Uber LLD → Chess → Hotel

For each: classes on paper first, code only core flow, then ask "what if they add X"

**Week 4–5 — System Design (easier problems first)**

- URL Shortener → Rate Limiter → Notification System → Search Autocomplete

For each problem, follow this structure every time:
```
1. Requirements (functional + non-functional)
2. Estimation (DAU → QPS → Storage)
3. API design
4. High level architecture
5. Deep dive on 1-2 bottlenecks
6. Trade-offs you made
```

**Week 6–7 — System Design (harder problems)**

- Chat System → News Feed → Uber HLD → YouTube

These are harder because they involve multiple concepts together (WebSockets + Kafka + sharding all in one).

**Week 8 — Mock interviews only**

Stop studying new things. Do 1 mock per day — LLD one day, HLD next day, alternate. Use Exponent, HelloInterview, or a friend.

---

## The one rule that ties everything together

**Never study a concept without a problem context.**

Always start with the problem, hit a gap, fill just that gap, return to the problem. Every time.
