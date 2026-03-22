# Auto Service

A brochure-style website for an auto repair shop built with `Ruby on Rails` and `Hotwire`.

We will use this file as the main project documentation source: goals, MVP scope, architectural decisions, and implementation stages should all be tracked here.

## Status Snapshot

Current implementation status as of the initial bootstrap:

- Rails application generated on `Rails 8.1.2`
- `SQLite`, `Propshaft`, `Importmap`, and `Hotwire` connected
- starter marketing pages implemented: `/`, `/about`, `/services`, `/contacts`, `/privacy`
- shared responsive layout and mobile navigation implemented
- `RSpec` selected as the project testing standard
- service request flow implemented with `Turbo`, `SQLite`, and a Rails model
- next major step: enrich the form workflow and replace placeholder business content

## 1. Project Goal

Build a modern, fast, and easy-to-understand website for an auto repair shop that:

- presents the shop's services and key advantages;
- helps customers contact the shop quickly;
- allows visitors to submit a service request or consultation request;
- works well on mobile devices;
- keeps the stack simple without a heavy frontend framework.

## 2. Project Format

Project type: marketing website with lightweight interactive elements.

Primary user flow:

1. Visit the website.
2. Quickly understand what services the shop provides.
3. See the main advantages, pricing guidance, or service categories.
4. Submit a callback or booking request.
5. Find the address, phone number, business hours, and map.

## 3. Technology Stack

- `Ruby on Rails`
- `Hotwire`
  - `Turbo` for fast navigation and partial page updates
  - `Stimulus` for lightweight interactivity
- `SQLite`
- `Propshaft` for asset management
- `Importmap` for JavaScript module loading without a bundler
- `RSpec` for all application tests

Principle: rely on Rails defaults as much as possible, use `Propshaft + Importmap`, and avoid unnecessary frontend complexity.

## 4. Design Direction

The visual direction should feel trustworthy, practical, and modern without looking generic or overdesigned.

### Design Theme

- style: clean industrial;
- tone: confident, clear, and service-oriented;
- focus: trust, clarity, and conversion;
- avoid: template-looking layouts, weak CTA placement, and overly decorative visuals.

### Visual Language

- primary palette: graphite, warm off-white, and safety orange;
- contrast style: strong dark/light contrast with a bold accent color;
- surfaces: soft texture, gradient, or subtle industrial shapes instead of flat empty backgrounds;
- imagery: real workshop, mechanics, tools, service bays, and customer trust moments.

### Typography

- headings: bold, expressive grotesk or industrial-style sans serif;
- body text: clean and highly readable sans serif;
- hierarchy: large headlines, short support text, and clear section rhythm.

### UI Principles

- strong CTA in the first screen;
- visible phone number above the fold;
- large buttons and clear form fields;
- simple service cards with concise descriptions;
- mobile-first spacing and layout decisions;
- restrained motion with meaningful reveals and transitions.

### Design Priorities

1. Define the visual mood and brand direction.
2. Build the UI foundation: colors, typography, spacing, buttons, cards, and form fields.
3. Design the home page sections.
4. Design the inquiry form and contact blocks.
5. Refine mobile behavior from the start, not at the end.

## 5. MVP Scope

The first version should include:

- home page;
- About section;
- services list;
- advantages section;
- inquiry form;
- contacts: phone, address, working hours, map;
- privacy policy page;
- basic SEO structure.

Not included in MVP:

- user accounts;
- full online payments;
- complex CRM features;
- multilingual support;
- a large admin module.

## 6. Site Structure

### Main Pages

#### Home `/`

Sections:

- hero section with a clear value proposition;
- short auto shop introduction;
- main services;
- benefits;
- work process;
- testimonials;
- inquiry form;
- contacts and map.

#### Services `/services`

Page with the main service categories:

- diagnostics;
- maintenance;
- suspension repair;
- engine repair;
- oil and filter replacement;
- tire service;
- auto electrical work.

Individual service detail pages can be added later if needed.

#### About `/about`

- shop story;
- qualifications;
- equipment;
- service approach.

#### Contacts `/contacts`

- phone number;
- messengers;
- address;
- business hours;
- map;
- contact form.

### Utility Pages

- `/privacy`
- `/thank-you` or a Turbo response after form submission

## 7. Core Entities

For the initial version, these entities are enough:

- `Inquiry`
  - name
  - phone
  - comment
  - inquiry type
  - processing status
- `Service`
  - title
  - slug
  - short description
  - full description
  - sort position
  - published flag
- `Review` (optional for MVP)
  - customer name
  - text
  - rating
  - published flag

If we need to move faster, `Service` data and testimonials can initially live in code or seeds and be moved to the database later.

## 8. How We Use Hotwire

We should use `Hotwire` only where it clearly improves UX:

- submitting the inquiry form without a full page reload;
- rendering success and validation states through `Turbo Frame`;
- interactive service tabs or accordions via `Stimulus`;
- FAQ toggles;
- phone input enhancements and other form improvements via `Stimulus`;
- smooth block switching or lightweight filtering without turning the project into an SPA.

The project should stay server-rendered. Rails HTML remains the foundation.

## 9. Home Page Content Blocks

### Hero

- strong headline;
- short offer;
- CTA button: "Book Now" / "Request a Call";
- visible phone number above the fold.

### Services

- 6-8 main services;
- short descriptions;
- link to the full services page.

### Benefits

- experience;
- warranty on work;
- transparent pricing;
- fast turnaround;
- convenient location.

### Work Process

1. The customer submits a request.
2. The manager contacts the customer and confirms the details.
3. The car is accepted for diagnostics or repair.
4. The customer receives the completed work and recommendations.

### Testimonials

- 3-6 short reviews;
- no overload;
- trust-focused content.

### Contacts

- phone number;
- address;
- business hours;
- messenger buttons;
- embedded map.

## 10. Technical Implementation Plan

### Stage 1. Project Initialization

- create the Rails application;
- configure SQLite;
- set up the base layout;
- connect Hotwire;
- prepare shared styles and the first UI foundation.

Status: completed.

### Stage 2. Page Skeleton

- create static pages;
- build the header and footer;
- configure routes;
- add navigation and primary CTA elements.

Status: in progress.

### Stage 3. Content and Models

- create the `Inquiry` model;
- create `Service` if needed in the first iteration;
- populate the site with starter content;
- prepare seeds.

### Stage 4. Forms and Interactivity

- implement the inquiry form;
- add validations;
- add `Turbo` responses;
- connect `Stimulus` for UX improvements.

Status: core inquiry flow implemented.

### Stage 5. SEO and Trust Signals

- configure `title`, `meta description`, and Open Graph tags;
- create readable headings and URLs;
- add favicon, robots, and sitemap;
- create the privacy policy page.

### Stage 6. Testing and Release

- verify responsive behavior;
- test the form flow and validations;
- check performance and baseline accessibility;
- prepare deployment.

## 11. Suggested App Structure

```text
app/
  controllers/
    pages_controller.rb
    inquiries_controller.rb
    services_controller.rb
  models/
    inquiry.rb
    service.rb
  views/
    layouts/
    pages/
    inquiries/
    services/
  javascript/
    controllers/
config/
db/
```

## 12. First-Version Routes

Example:

```ruby
root "pages#home"

get "/about", to: "pages#about"
get "/contacts", to: "pages#contacts"
get "/privacy", to: "pages#privacy"

resources :services, only: [:index, :show]
resources :inquiries, only: [:create]
```

## 13. Decisions to Clarify Early

- brand style: colors, typography, and visual tone;
- final service list;
- contact details;
- business hours;
- whether we need a blog or promotions section;
- whether a simple admin area should be added later;
- where inquiries should be delivered: email, Telegram, CRM.

## 14. Risks and Responses

### Risk

The site may become a static set of sections without a clear business action.

### Response

Design around conversion from the start: prominent CTA, simple form, and visible contact information.

### Risk

Too much frontend complexity for a simple business website.

### Response

Stay within the Rails + Hotwire approach and avoid SPA tooling unless there is a real need.

### Risk

Not enough trust-building content.

### Response

Prepare real advantages, testimonials, service photos, and clear warranty language early.

## 15. Post-MVP Roadmap

- admin panel for editing services and reviews;
- work gallery;
- promotions and special offers section;
- FAQ;
- blog with car maintenance articles;
- Telegram/email notifications;
- online booking with time slot selection.

## 16. Fly.io Deployment

The project has been prepared for deployment to `https://fly.io/` with a single-machine `SQLite` setup.

### Added Configuration

- [fly.toml](/home/dandy/projects/auto_service/fly.toml)
- production database paths now support persistent volume mounts via environment variables in [database.yml](/home/dandy/projects/auto_service/config/database.yml)
- production host and SSL behavior now adapt to Fly in [production.rb](/home/dandy/projects/auto_service/config/environments/production.rb)

### Deployment Assumptions

- single Fly machine;
- persistent volume mounted at `/data`;
- `SQLite` remains the production database;
- no multi-region write setup;
- suitable for a brochure website with low write volume.

### Fly Setup Steps

1. Install and authenticate `flyctl`.
2. Adjust the app name in [fly.toml](/home/dandy/projects/auto_service/fly.toml) if `auto-service` is unavailable.
3. Create the Fly app:
   - `fly apps create auto-service`
4. Create the persistent volume:
   - `fly volumes create data --region lhr --size 1`
5. Set the Rails master key:
   - `fly secrets set RAILS_MASTER_KEY=$(cat config/master.key)`
6. Deploy:
   - `fly deploy`

### Notes

- `fly.toml` currently uses region `lhr` as a practical default for Ireland.
- The app is configured to keep one machine running.
- If the project later needs multiple regions or multi-writer SQLite, we should revisit the setup and likely move to `LiteFS` or `PostgreSQL`.

## 17. Immediate Next Steps

1. Implement the request/inquiry flow with a Rails model and `Turbo`.
2. Replace placeholder workshop data with real business content.
3. Add an admin-friendly workflow or simple back-office view for submitted inquiries.
4. Add database-backed services or seeds for editable service content.
5. Expand SEO metadata and social sharing tags.
6. Add system specs in `RSpec` for the customer request flow.

## 18. Documentation Rule

All project documentation must be written in English.

In this `README.md`, we should track:

- approved architectural decisions;
- changes to MVP scope;
- new entities and pages;
- integration decisions;
- implementation stages and status.

If the project grows, we can later move detailed documentation into a `docs/` directory while keeping `README.md` as the main entry point.
