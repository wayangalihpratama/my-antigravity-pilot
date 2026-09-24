---
name: frontend-design
description: Guidance for distinctive, intentional visual design when building new UI or reshaping an existing one. Helps with aesthetic direction, typography, and making choices that don't read as templated defaults.
---

# Frontend Design: Distinctive, High-Fidelity UI Engineering

Approach this as the design lead at a top-tier digital product studio known for giving every project a memorable, authentic visual identity. The client has already rejected proposals that felt cliché or templated, and is paying for an opinionated, distinctive point of view: make deliberate choices about palette, typography, and layout that are specific to this brief, and take calculated aesthetic risks when justified.

---

## 🎯 1. Ground Designs in Authentic Subject Matter

If the brief does not explicitly define the industry or brand identity, discover or propose it before writing code:
- **Audience & Context**: A financial analytics portal requires tight data density, monospace tabular figures, and high-contrast neutral borders. A local artisan bakery needs organic textures, warm ambient contrast, and generous whitespace.
- **Visual Vernacular**: Derive typography, iconography, and spatial density directly from the materials, tools, and history of the client's field.
- **Build with Real Content**: Never design with "Lorem Ipsum" or generic filler text. Draft realistic domain copy (actual product titles, realistic prices, specific feature names) throughout the UI.

---

## 🚫 2. The 5 AI Design Clichés to Avoid (Negative Calibration)

AI-generated interfaces overwhelmingly cluster around predictable tropes. Avoid these default patterns unless explicitly demanded by the user brief:

| AI Cliché / Tell | Why It Feels Templated | What to Do Instead |
|---|---|---|
| **Warm Cream + Terracotta** | `#F4F1EA` background with `#D97757` terracotta accent and high-contrast serif. | Pick an authentic palette derived from the subject matter (e.g. deep slate + cobalt, muted olive + sage, charcoal + electric amber). |
| **The SaaS Card Kit** | Every piece of content chopped into identical rounded cards with soft grey shadows (`rgba(0,0,0,0.08)`). | Use structural hierarchy: asymmetric grids, editorial rule dividers (`border-t border-slate-200`), background tonal shifts, and borderless groups. |
| **Tracked-Out Eyebrows** | `ALL-CAPS` small label with `tracking-widest` above every single heading. | Use natural sentence case headings, inline badges only where status is conveyed, or distinct typographic scales without artificial eyebrows. |
| **Headline Word Highlighting** | Randomly making *one word* in a headline italicized, bolded, or highlighted in accent color. | Let the complete typographic statement carry the weight. Emphasize hierarchy through size, weight, and line-breaks. |
| **Scattered Motion** | `fade-in-up` transitions on every scroll section and hover lifts on every card. | Implement a single orchestrated entrance sequence or reserve animation strictly for user-initiated interactions (expanding accordion, modal pop). |

---

## 📐 3. The Two-Pass Design Process

### Pass 1: Compact Design Plan (Tokens & ASCII Wireframes)
Before writing HTML/CSS, formulate a deliberate design plan:
1. **Core Palette (4–6 Named Hex Tokens)**:
   ```css
   /* Example: Industrial Logistics Brand */
   --bg-canvas: #0f172a;       /* Deep slate base */
   --bg-surface: #1e293b;      /* Card / elevated surface */
   --border-subtle: #334155;   /* Structural grid borders */
   --text-primary: #f8fafc;    /* High-legibility crisp text */
   --text-secondary: #94a3b8;  /* Supporting metadata */
   --accent-signal: #f59e0b;   /* High-visibility amber CTA */
   ```
2. **Typographic Hierarchy**:
   - Primary Display Face: 1 intentional family with defined optical weights.
   - Body & Data Face: Highly legible standard or monospace font for tabular numbers.
   - Type scale based on *The Elements of Typographic Style* ratios (e.g., Major Third `1.25` or Perfect Fourth `1.333`).
3. **ASCII Layout Concept**:
   ```
   ┌─────────────────────────────────────────────────────────────┐
   │ [Brand Logo]                        [Nav Links]  [Order CTA]│
   ├────────────────────────────────────────┬────────────────────┤
   │ Editorial Hero Statement               │ Live Interactive   │
   │ "Precision steel fabrication for       │ Dimension Selector │
   │ heavy aerospace infrastructure."       │ [ 24mm | 48mm ]    │
   │                                        │                    │
   │ [Request Spec Sheet ->]                │ [ Instant Quote ]  │
   ├────────────────────────────────────────┴────────────────────┤
   │ Metric Strip: 99.94% Tolerance │ ISO-9001 Certified │ 48h SLA │
   └─────────────────────────────────────────────────────────────┘
   ```

### Pass 2: Self-Critique & Build
Critique the plan against the brief before writing code:
- *Does any section feel like a generic SaaS template?*
- *Apply Chanel's rule*: Look at the interface and remove one unnecessary decorative border, shadow, or tag.
- Check CSS selector specificity: Ensure utility classes or component scopes do not override each other unintentionally.

---

## ✍️ 4. Intentional UI Copywriting & Microcopy

Words are functional UI elements, not decorative placeholders:
- **Active Voice CTAs**: Write exactly what occurs upon click ("Deploy to Production" instead of "Submit", "Download PDF Spec" instead of "Click Here").
- **State-Consistent Vocabulary**: If a button says "Generate Invoice", the toast notification must say "Invoice Generated".
- **Actionable Error States**: Never show vague apologies like *"Oops! Something went wrong"*. State what failed and how to resolve it (*"Unable to connect to payment gateway. Please check your card number or try PayPal."*).
- **Directional Empty States**: Treat empty tables/lists as invitations to take action with a direct button.
