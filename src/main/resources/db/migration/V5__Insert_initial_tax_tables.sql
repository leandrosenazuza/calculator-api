-- Migration: Insert initial tax tables
-- Version: 5
-- Description: Inserts initial tax calculation tables from JSON files into the database

-- Insert tab01.json
INSERT INTO tax_tables (name, description, data, active, created_at, updated_at)
VALUES (
    'tab01',
    'Tabela de taxas 01 - Visa/Master e Elo',
    '{"visa_master":{"debito":0.9887,"credito_a_vista":0.9689,"coeficientes":{"2":0.9571,"3":0.9488,"4":0.9405,"5":0.9322,"6":0.9239,"7":0.9156,"8":0.9037,"9":0.8954,"10":0.8871,"11":0.8788,"12":0.8705,"13":0.8589,"14":0.8506,"15":0.8423,"16":0.834,"17":0.8257,"18":0.8174}},"elo":{"debito":0.9851,"credito_a_vista":0.9661,"coeficientes":{"2":0.9521,"3":0.9438,"4":0.9355,"5":0.9272,"6":0.9189,"7":0.9089,"8":0.9006,"9":0.8923,"10":0.884,"11":0.8757,"12":0.8674,"13":0.8568,"14":0.8485,"15":0.8402,"16":0.8319,"17":0.8236,"18":0.8153}}}'::jsonb,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (name) DO NOTHING;

-- Insert tab02.json
INSERT INTO tax_tables (name, description, data, active, created_at, updated_at)
VALUES (
    'tab02',
    'Tabela de taxas 02 - Visa/Master e Elo',
    '{"visa_master":{"debito":0.9861,"credito_a_vista":0.9661,"coeficientes":{"2x":0.9473,"3x":0.9393,"4x":0.9315,"5x":0.9237,"6x":0.916,"7x":0.904,"8x":0.8965,"9x":0.889,"10x":0.8817,"11x":0.8744,"12x":0.8672,"13x":0.8584,"14x":0.8514,"15x":0.8444,"16x":0.8375,"17x":0.8307,"18x":0.8239}},"elo":{"debito":0.9821,"credito_a_vista":0.9631,"coeficientes":{"2x":0.9429,"3x":0.9349,"4x":0.9271,"5x":0.9193,"6x":0.9116,"7x":0.902,"8x":0.8945,"9x":0.887,"10x":0.8797,"11x":0.8724,"12x":0.8652,"13x":0.8574,"14x":0.8504,"15x":0.8434,"16x":0.8365,"17x":0.8297,"18x":0.8229}}}'::jsonb,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (name) DO NOTHING;

-- Insert Tab 03.json
INSERT INTO tax_tables (name, description, data, active, created_at, updated_at)
VALUES (
    'Tab 03',
    'Tabela de taxas 03 - Visa/Master e Elo',
    '{"visa_master":{"debito":0.9861,"credito_a_vista":0.9661,"coeficientes":{"2x":0.9473,"3x":0.9393,"4x":0.9315,"5x":0.9237,"6x":0.916,"7x":0.904,"8x":0.8965,"9x":0.889,"10x":0.8817,"11x":0.8744,"12x":0.8672,"13x":0.8584,"14x":0.8514,"15x":0.8444,"16x":0.8375,"17x":0.8307,"18x":0.8239}},"elo":{"debito":0.9821,"credito_a_vista":0.9631,"coeficientes":{"2x":0.9429,"3x":0.9349,"4x":0.9271,"5x":0.9193,"6x":0.9116,"7x":0.902,"8x":0.8945,"9x":0.887,"10x":0.8797,"11x":0.8724,"12x":0.8652,"13x":0.8574,"14x":0.8504,"15x":0.8434,"16x":0.8365,"17x":0.8297,"18x":0.8229}}}'::jsonb,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (name) DO NOTHING;

-- Insert debito.json
INSERT INTO tax_tables (name, description, data, active, created_at, updated_at)
VALUES (
    'debito',
    'Tabela de taxas para débito',
    '{"visa_master":{"debito":0.9911,"credito_a_vista":0.9692,"coeficientes":{"2x":0.9583,"3x":0.9513,"4x":0.9441,"5x":0.9372,"6x":0.9303,"7x":0.9224,"8x":0.9157,"9x":0.909,"10x":0.9023,"11x":0.8957,"12x":0.8892,"13x":0.8757,"14x":0.8693,"15x":0.8629,"16x":0.8567,"17x":0.8504,"18x":0.8443}},"elo":{"debito":0.9811,"credito_a_vista":0.9645,"coeficientes":{"2x":0.9483,"3x":0.9413,"4x":0.9341,"5x":0.9272,"6x":0.9203,"7x":0.9093,"8x":0.9053,"9x":0.8959,"10x":0.8895,"11x":0.8826,"12x":0.8761,"13x":0.8672,"14x":0.8608,"15x":0.8544,"16x":0.8481,"17x":0.8419,"18x":0.8358}}}'::jsonb,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (name) DO NOTHING;

-- Insert parced.json
INSERT INTO tax_tables (name, description, data, active, created_at, updated_at)
VALUES (
    'parced',
    'Tabela de taxas parceladas',
    '{"visa_master":{"debito":0.9871,"credito_a_vista":0.969,"coeficientes":{"2x":0.9577,"3x":0.9506,"4x":0.9435,"5x":0.9365,"6x":0.9296,"7x":0.9224,"8x":0.9156,"9x":0.9089,"10x":0.9022,"11x":0.8957,"12x":0.8891,"13x":0.8796,"14x":0.8732,"15x":0.8669,"16x":0.8606,"17x":0.8544,"18x":0.8482}},"elo":{"debito":0.9815,"credito_a_vista":0.9637,"coeficientes":{"2x":0.9532,"3x":0.9461,"4x":0.939,"5x":0.932,"6x":0.9251,"7x":0.9178,"8x":0.911,"9x":0.9043,"10x":0.8976,"11x":0.8911,"12x":0.8845,"13x":0.8761,"14x":0.8697,"15x":0.8634,"16x":0.8571,"17x":0.8509,"18x":0.8447}}}'::jsonb,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (name) DO NOTHING;

