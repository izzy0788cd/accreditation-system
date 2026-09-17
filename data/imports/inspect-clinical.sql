SELECT json_build_object('standards',(SELECT json_agg(s) FROM standards s),'functions',(SELECT json_agg(f) FROM functions f),'components',(SELECT json_agg(c) FROM components c));
