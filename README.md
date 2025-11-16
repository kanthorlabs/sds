# SDS
> Simple Data Store (SDS) is a high-performance, embedded data store built in Rust, leveraging Object Storage for high durability and flexibility large objects.

## Introduction

To mitigate high write API costs (PUTs), SDS batches writes.

To mitigate consistency concerns, SDS allows configurable write durability levels.

To mitigate read latency and read API costs (GETs), SDS uses use standard LSM-tree caching techniques.