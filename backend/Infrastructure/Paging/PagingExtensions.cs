using Microsoft.EntityFrameworkCore;

namespace backend.Infrastructure.Paging;

public static class PagingExtensions
{
    public static async Task<PagedResult<T>> ToPagedResultAsync<T>(this IQueryable<T> query, PageQuery pageQuery, CancellationToken cancellationToken)
    {
        var total = await query.CountAsync(cancellationToken);
        var items = await query.Skip((pageQuery.SafePage - 1) * pageQuery.SafePageSize)
            .Take(pageQuery.SafePageSize).ToListAsync(cancellationToken);
        return new PagedResult<T>(items, total, pageQuery.SafePage, pageQuery.SafePageSize);
    }
}
