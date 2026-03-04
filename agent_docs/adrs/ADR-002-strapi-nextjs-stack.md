# ADR-002: Strapi v5 + Next.js (App Router) Stack

## Status
Proposed

## Context
The user wants to add a new tech stack to the repository that mirrors the `climate-think-and-do-tank` project. The guidance project uses Strapi (v4 likely) and Next.js (Pages Router). However, current best practices suggest moving to Strapi v5 and Next.js App Router for better performance, type safety, and longevity.

## Decision
We will implement the new stack using:
1. **Strapi v5**: Leveraging the new Document Service, TypeScript-first approach, and flattened API responses.
2. **Next.js 15 (App Router)**: Following modern React patterns, Server Components, and optimized data fetching.
3. **Docker-first Workflow**: Following the repository's convention of running all commands via Docker containers.
4. **Config-Sync**: Essential for maintaining schema versions across environments.

## Consequences
- **Pros**:
  - Better developer experience with full TypeScript.
  - Improved runtime performance (Vite for Strapi, App Router for Next.js).
  - Modern architecture ready for the future.
- **Cons**:
  - Slight divergence from the guidance project (v4 -> v5, Pages -> App) might require careful translation of some patterns.
  - Some v4 plugins might not be v5-ready yet.
