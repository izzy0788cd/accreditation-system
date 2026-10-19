SELECT json_build_object(
 'existing', (SELECT json_agg(s) FROM standards s WHERE "standardNumber"='26' OR lower("standardTitle") LIKE '%blood%'),
 'neighbours', (SELECT json_agg(s) FROM standards s WHERE "standardNumber" IN ('24','25','27')),
 'functions', (SELECT json_agg(f) FROM functions f),
 'components', (SELECT json_agg(c) FROM components c));
