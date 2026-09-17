namespace backend.Infrastructure.Paging;

/// <summary>Shared query parameters for list endpoints.</summary>
public sealed class PageQuery
{
    public int? Page { get; init; }
    public int? PageSize { get; init; }
    public string? Search { get; init; }
    public string? Sort { get; init; }
    public string? Direction { get; init; }

    public bool IsPaged => Page.HasValue || PageSize.HasValue;
    public int SafePage => Math.Max(1, Page ?? 1);
    public int SafePageSize => Math.Clamp(PageSize ?? 25, 1, 100);
    public bool IsDescending => string.Equals(Direction, "desc", StringComparison.OrdinalIgnoreCase);
}
