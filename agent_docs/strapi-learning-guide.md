# Strapi v5 Learning Guide: From Concepts to Real-World Implementation

This guide provides an in-depth look at Strapi v5, specifically leveraging patterns found in the `climate-think-and-do-tank` guidance project and the [Strapi v5 Documentation](https://docs.strapi.io/cms/intro).

---

## 1. Core Architecture (The v5 Standard)

Strapi v5 introduces significant improvements in content management and developer experience.

### Backend Structure Breakdown
```text
backend/
├── src/
│   ├── api/                  # Business-specific APIs
│   │   └── [api-name]/       # e.g., "investment-opportunity-profile"
│   │       ├── content-types/# JSON Schemas (Structure)
│   │       ├── controllers/  # Logic (Data Processing)
│   │       ├── routes/       # Endpoints (URL -> Controller)
│   │       └── services/     # Reusable query logic
│   ├── components/           # Reusable blocks (shared.slider, shared.seo)
│   └── index.js              # Project bootstrap and registration
├── config/
│   ├── plugins.js            # Configuration for Uploads, Email, GraphQL, and Config-Sync
│   └── sync/                 # JSON files for database configuration versioning
```

---

## 2. Real-World Implementation Examples

### A. Modular Data Fetching (HeroSlider.js)
The guidance project shows a clean pattern for fetching Single Type data in Next.js.

**Code Example: `frontend/components/HeroSlider.js`**
```javascript
const fetchHomepageData = async () => {
  try {
    const response = await axios.get(
      `${backendUrl}/api/homepage?populate=homepage_video`
    );

    if (response.data && response.data.data) {
      const homepageData = response.data.data;

      // Strapi v5 flattened response allows direct access
      const heroInfo = {
        title: homepageData.homepage_blurb || 'Default Title',
        videoUrl: getImageUrl(homepageData.homepage_video)
      };

      setHeroData(heroInfo);
    }
  } catch (err) {
    console.error('Failed to load homepage data', err);
  }
};
```
> [!TIP]
> **Populate API**: Always specify which relations or media you want to fetch using `?populate=*` or specific fields.

---

### B. Scalable Collection Type Schema
Large features like the `Investment Opportunity Profile` demonstrate how to use **Relations** and **Components** together.

**Schema Example: `investment-opportunity-profile/schema.json`**
```json
{
  "kind": "collectionType",
  "attributes": {
    "title": { "type": "string" },
    "value_chain": {
      "type": "relation",
      "relation": "oneToOne",
      "target": "api::value-chain.value-chain"
    },
    "regions": {
      "type": "relation",
      "relation": "oneToMany",
      "target": "api::region.region"
    },
    "investment_opportunity_column1_items": {
      "type": "component",
      "repeatable": true,
      "component": "shared.checklist-item"
    }
  }
}
```

---

### C. Advanced Logic: Custom Controllers
Custom endpoints are essential for features like checking email availability without exposing the full user list.

**Example: `api/email-check/controllers/email-check.js`**
```javascript
module.exports = {
  async isEmailRegistered(ctx) {
    const { email } = ctx.request.body;
    if (!email) return ctx.badRequest('Missing email parameter');

    // querying the users-permissions plugin directly
    const existingUser = await strapi.db
      .query('plugin::users-permissions.user')
      .findOne({ where: { email } });

    return ctx.send({ exists: !!existingUser });
  }
};
```

---

## 3. How to Use & Workflow

1.  **Define Structure**: Create Collections (News, Events) and Single Types (Homepage) in Admin.
2.  **Modularize UI**: Use Components (`shared.slider`, `shared.seo`) for repeatable blocks.
3.  **Sync Config**: Use `strapi-plugin-config-sync` to keep your local schema changes in Git.
4.  **Fetch on Frontend**: Use the `/api/...` endpoints with `populate` to get your content.

---

## 4. Key Takeaways for Your New Stack

When we build the `strapi-nextjs` stack, we will:
- **Default to v5**: Utilizing the flattened response format.
- **Implement Config-Sync** from day one for seamless deployments.
- **Create Page Builder Patterns** using Dynamic Zones and shared Components.
- **Use Next.js 15 (App Router)** for modern, server-side data fetching.

**Reference Links:**
- [Strapi v5 Feature Overview](https://strapi.io/v5)
- [Managing Content Types](https://docs.strapi.io/user-docs/content-type-builder)
- [API Reference](https://docs.strapi.io/dev-docs/api/rest)
