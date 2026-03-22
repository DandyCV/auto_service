# Auto Service

`Auto Service` is a brochure-style website for a small auto repair shop built with `Ruby on Rails` and `Hotwire`.

The project focuses on:

- clear presentation of workshop services;
- fast customer contact and service request submission;
- responsive mobile-first UX;
- lightweight Rails-first architecture without a heavy frontend stack;
- a simple admin area for managing incoming requests.

## Current Stack

- `Rails 8`
- `Hotwire` (`Turbo` + `Stimulus`)
- `SQLite`
- `Propshaft`
- `Importmap`
- `RSpec`

## Main Features

- public pages: Home, About, Services, Contacts, Privacy;
- `Turbo` service request form;
- Google Maps and Waze quick navigation links;
- admin login page;
- admin request table with filtering, pagination, editing, and deletion.

## Deployment

The project is being prepared for deployment on `https://fly.io/` with a single-machine `SQLite` setup backed by a persistent Fly volume.

## Documentation

Full project documentation has been moved to [doc.md](/home/dandy/projects/auto_service/doc.md).
