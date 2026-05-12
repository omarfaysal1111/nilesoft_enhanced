# Nile Soft ERP — Enhanced Flutter Client

Enterprise software enhancement project for Nile Soft — a scalable Flutter
client with refined architecture, improved performance, and clean engineering
practices on top of an existing ERP backend.

## What This Is

A Flutter application refactor and enhancement engagement. The goal was to
re-architect the mobile client layer of an existing enterprise ERP system
using Clean Architecture principles, improving maintainability, performance,
and feature velocity.

## Tech Stack

- **Mobile:** Flutter · Dart
- **Architecture:** Clean Architecture · MVVM · Repository Pattern
- **Backend Integration:** RESTful API consumption · JWT Auth
- **State Management:** BLoC / Riverpod
- **Enterprise Domain:** ERP · Inventory · Order Management

## Key Engineering Decisions

- Migrated spaghetti widget trees to proper Clean Architecture layers
  (Data → Domain → Presentation)
- Introduced repository abstraction layer to decouple API calls from UI logic
- Implemented role-based UI rendering tied to backend RBAC permissions
- Optimized list rendering performance for large ERP data sets

## Architecture

```
Presentation Layer  (Flutter Widgets + BLoC)
        │
   Domain Layer     (Use Cases + Entities)
        │
   Data Layer       (Repositories + API Services)
        │
   ERP Backend      (External REST API)
```
