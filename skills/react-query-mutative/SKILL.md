---
name: react-query-mutative
description: "Use when writing React Query mutations with optimistic updates, configuring QueryClient, creating query key factories, or structuring API modules with queries and mutations."
---

## QueryClient Configuration

File: `libs/query/root-provider.tsx`

- `staleTime: Infinity` — data never goes stale automatically
- `gcTime: Infinity` — never garbage-collected
- `refetchOnMount: false`
- `refetchOnWindowFocus: false`
- `retry: false`
- Manual freshness control: call `invalidateQueries` or `setQueryData` in mutation `onSuccess`
- Global `MutationCache.onError` → `toast.error(error.message)` via sonner
- Global `QueryCache.onError` → `toast.error(error.message)` for failed queries

## Query Key Factories

One factory per domain in `api/<domain>/keys.ts`:

```typescript
export const contactKeys = {
  all: ['contacts'] as const,
  lists: () => [...contactKeys.all, 'list'] as const,
  list: (filters: ContactFilters) => [...contactKeys.lists(), filters] as const,
  details: () => [...contactKeys.all, 'detail'] as const,
  detail: (id: string) => [...contactKeys.details(), id] as const,
}
```

## Optimistic Updates via mutative

File: `libs/query/optimistic.ts`

```typescript
import { create } from 'mutative'

type RollbackFn = () => void

export function optimisticUpdate<TData>(
  queryClient: QueryClient,
  queryKey: QueryKey,
  updater: (draft: TData) => void,
): RollbackFn {
  const previous = queryClient.getQueryData<TData>(queryKey)
  if (previous) {
    queryClient.setQueryData(queryKey, create(previous, updater))
  }
  return () => queryClient.setQueryData(queryKey, previous)
}

export function optimisticRemove<TItem>(
  queryClient: QueryClient,
  queryKey: QueryKey,
  predicate: (item: TItem) => boolean,
): RollbackFn {
  return optimisticUpdate<TItem[]>(queryClient, queryKey, (draft) => {
    const idx = draft.findIndex(predicate)
    if (idx !== -1) draft.splice(idx, 1)
  })
}

export function optimisticAdd<TItem>(
  queryClient: QueryClient,
  queryKey: QueryKey,
  item: TItem,
  position: 'start' | 'end' = 'end',
): RollbackFn {
  return optimisticUpdate<TItem[]>(queryClient, queryKey, (draft) => {
    position === 'start' ? draft.unshift(item) : draft.push(item)
  })
}

export function rollback(...fns: RollbackFn[]) {
  return () => fns.forEach((fn) => fn())
}

export function settle(queryClient: QueryClient, queryKeys: QueryKey[]) {
  return () => queryKeys.forEach((key) => queryClient.invalidateQueries({ queryKey: key }))
}
```

## Concurrent Mutation Safety

For builders/editors with rapid successive mutations:

- Use a shared `mutationKey` across related mutations
- Guard with `isMutating()` — skip `setQueryData` unless last pending
- Only call `settle` if `isLastPendingMutation()`
- Always call `router.invalidate()` in `onSettled`

## API Module Pattern

Four files per domain under `api/<domain>/`:

| File | Contents |
|---|---|
| `schemas.ts` | Zod v4 schemas + inferred types |
| `functions.ts` | `createServerFn` handlers |
| `keys.ts` | Query key factories |
| `hooks.ts` | `useQuery` / `useMutation` wrappers |
