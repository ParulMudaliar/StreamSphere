# StreamSphere Database

A relational database design for a smart streaming and content analytics platform, built for IS 455 (Database Design and Prototyping) at the University of Illinois Urbana-Champaign, Spring 2026.

**Live case study:** [link to showcase page once hosted]

## What's in this repo

| File | Description |
|---|---|
| `Mysql_tables.sql` | Full MySQL implementation: 20 `CREATE TABLE` statements in referential dependency order, sample data (5+ rows per table), the ACTORS-to-junction-table migration, and all 10 SQL queries |
| `StreamSphere_FinalReport.pdf` | Complete project report: scenario, requirements, EERD, relational schema, normalization analysis (1NF–3NF), SQL queries with results, and MongoDB conversion analysis |
| `creators_actors.json` | MongoDB document model for the CREATOR and ACTOR collections (referenced, not embedded) |
| `viewers.json` | MongoDB document model for VIEWER, with `subscription_plan` embedded and `history`/`payment` as ObjectId references |
| `tv_shows.json` | MongoDB document model for TV_SHOWS, with `seasons` and `episodes` embedded as nested arrays |
| `movies.json` | MongoDB document model for the MOVIES collection |
| `history.json` | MongoDB document model for the HISTORY collection (referenced from VIEWER) |
| `payments.json` | MongoDB document model for the PAYMENT collection (referenced from VIEWER) |

## Project summary

StreamSphere Inc. is a streaming platform combining subscription-based content consumption with creator-driven uploads. The database supports three disjoint user roles (Viewer, Creator, Administrator), a three-way content specialization (Movies, TV Shows, Short Clips), TV show season/episode hierarchies, subscription and payment tracking, and viewing history with completion analytics.

**Schema:** 20 normalized tables, verified against 1NF, 2NF, and 3NF.

**MongoDB conversion:** every relationship was run through a three-question test (co-access, document scope, boundedness) to decide between embedding and referencing. Subscription plans and TV show season/episode hierarchies are embedded; viewing history, payments, actors, and creators are referenced.

## Team

- Parul Mudaliar
- Prathamesh Mulay
- Anisha Kango
- Chaitanya Nirantar

IS 455, Spring 2026, University of Illinois Urbana-Champaign.
