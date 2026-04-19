CREATE TABLE users (
    id BIGINT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE,
    password_hash VARCHAR(255),
    gov_id_number VARCHAR(20) UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_flag BOOLEAN DEFAULT FALSE
);


CREATE TABLE roles (
    id BIGINT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    deleted_flag BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_roles (
    id BIGINT  PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_flag BOOLEAN DEFAULT FALSE,
    
    CONSTRAINT fk_user
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_role
        FOREIGN KEY(role_id) REFERENCES roles(id) ON DELETE CASCADE,
        
    CONSTRAINT unique_user_role UNIQUE (user_id, role_id)
);

CREATE TABLE permissions (
    id BIGINT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
        deleted_flag BOOLEAN DEFAULT FALSE
);



CREATE TABLE role_permissions (
    id BIGINT PRIMARY KEY,
    role_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,
    deleted_flag BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_role_perm
        FOREIGN KEY(role_id) REFERENCES roles(id) ON DELETE CASCADE,
    CONSTRAINT fk_permission
        FOREIGN KEY(permission_id) REFERENCES permissions(id) ON DELETE CASCADE,
    CONSTRAINT unique_role_permission UNIQUE (role_id, permission_id)
);


CREATE TABLE otp_requests (
    id BIGINT PRIMARY KEY,
    phone VARCHAR(15) NOT NULL,
    otp_code VARCHAR(10) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    attempts INT DEFAULT 0,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted_flag BOOLEAN DEFAULT FALSE
);


CREATE TABLE user_sessions (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    access_token TEXT NOT NULL,
    refresh_token TEXT NOT NULL,
    is_logged_in BOOLEAN DEFAULT FALSE,
    device_info VARCHAR(255),
    ip_address VARCHAR(50),
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted_flag BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_session_user
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE user_locations (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted_flag BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_location_user
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE user_regions (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    region_name VARCHAR(100),
    region_code VARCHAR(50),
        deleted_flag BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_region_user
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE emergency_access_logs (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role_id BIGINT,
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    reason TEXT,
        deleted_flag BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_emergency_user
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_emergency_role
        FOREIGN KEY(role_id) REFERENCES roles(id) ON DELETE SET NULL
);


CREATE TABLE api_rate_limits (
    id BIGINT PRIMARY KEY,
    user_id BIGINT,
    request_count INT DEFAULT 0,
    window_start TIMESTAMP,
        deleted_flag BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_rate_user
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);



CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_otp_phone ON otp_requests(phone);
CREATE INDEX idx_audit_user_id ON audit_logs(user_id);