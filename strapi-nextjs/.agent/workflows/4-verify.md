---
description: Verify phase - run full validation suite
---

1. Run all backend tests: `./dc.sh exec backend npm test`.
2. Run all frontend tests: `./dc.sh exec frontend npm test`.
3. Check code style: `./dc.sh exec frontend npm run lint`.
4. Perform manual UI check if applicable.
