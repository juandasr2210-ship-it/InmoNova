-- Cambio puntual: Girón -> Cartagena (misma ficha MI-DEMO-003)
USE inmonova;
UPDATE propiedad p
INNER JOIN ciudad c ON c.nombre='Cartagena'
INNER JOIN tipo_propiedad t ON t.nombre='apartamento'
SET p.id_ciudad=c.id_ciudad, p.id_tipo=t.id_tipo,
    p.titulo='Apartamento Bocagrande vista al mar',
    p.descripcion='Apartamento con vista a la bahía, 2 alcobas, balcón amplio y piscina comunitaria.',
    p.precio=385000000, p.direccion='Cra 1 # 12-50, Bocagrande'
WHERE p.matricula_inmobiliaria='MI-DEMO-003';
UPDATE imagen_propiedad SET url='https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=600'
WHERE id_propiedad=(SELECT id_propiedad FROM propiedad WHERE matricula_inmobiliaria='MI-DEMO-003');
INSERT IGNORE INTO propiedad_caracteristica(id_propiedad,id_caracteristica)
SELECT p.id_propiedad, ca.id_caracteristica FROM propiedad p, caracteristica ca
WHERE p.matricula_inmobiliaria='MI-DEMO-003' AND ca.nombre IN ('balcon','piscina');
