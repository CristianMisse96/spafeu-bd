
CREATE TYPE token_status_type AS ENUM (
    'ACTIVE',
    'USED',
    'EXPIRED',
	'REVOKED'
);

CREATE TYPE nivel_actividad_fisica_type AS ENUM (
    'NIVEL_1',
    'NIVEL_2',
    'NIVEL_3',
    'NIVEL_4'
);

CREATE TYPE role_type AS ENUM (
    'ROLE_USER',
    'ROLE_SUPERVISOR',
    'ROLE_SUPERADMIN',
    'ROLE_ADMIN',
    'ROLE_VALIDADOR',
    'ROLE_VALIDADOR_WALLET'
);

CREATE TYPE estado_kyc_type AS ENUM (
    'NO_INICIADO',
    'COMPLETO'
);