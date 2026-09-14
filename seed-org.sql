INSERT INTO categories ("categoryName", description)
VALUES ('National Department of Health', 'Default demo category.');

INSERT INTO organizations ("organizationName", "categoryId", description)
SELECT 'Demo Organization', c."categoryId", 'Default demo organization for training.'
FROM categories c WHERE c."categoryName" = 'National Department of Health';