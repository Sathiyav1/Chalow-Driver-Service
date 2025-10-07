-- V1__Initial_Schema.sql
-- Initial database schema creation with PostGIS and normalized contact information

-- Enable PostGIS extension
CREATE
    EXTENSION IF NOT EXISTS postgis;
CREATE
    EXTENSION IF NOT EXISTS postgis_topology;

-- Core users table (updated to match User entity)
CREATE TABLE users
(
    id                  BIGSERIAL PRIMARY KEY,
    first_name          VARCHAR(255) NOT NULL,
    last_name           VARCHAR(255) NOT NULL,
    date_of_birth       TIMESTAMP,
    user_type           VARCHAR(20)  NOT NULL CHECK (user_type IN ('RIDER', 'DRIVER', 'BOTH')),
    is_driver           BOOLEAN               DEFAULT false,
    last_known_location GEOMETRY(Point, 4326),
    average_rating      DOUBLE PRECISION      DEFAULT 0.0,
    total_rides         INTEGER               DEFAULT 0,
    is_active           BOOLEAN               DEFAULT true,
    is_online           BOOLEAN               DEFAULT false,
    has_face            BOOLEAN               DEFAULT false,
    face_verified       BOOLEAN               DEFAULT false,
    created_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login_at       TIMESTAMP
);

-- User authentication table
CREATE TABLE user_authentication
(
    id            BIGSERIAL PRIMARY KEY,
    user_id       BIGINT    NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    auth0_id      VARCHAR(255) UNIQUE,
    keycloak_id   VARCHAR(255) UNIQUE,
    auth_provider VARCHAR(20)        DEFAULT 'keycloak',
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_auth_provider CHECK (auth_provider IN ('auth0', 'keycloak')),
    CONSTRAINT chk_at_least_one_auth_id CHECK (auth0_id IS NOT NULL OR keycloak_id IS NOT NULL)
);

-- Normalized email addresses table
CREATE TABLE user_emails
(
    id                   BIGSERIAL PRIMARY KEY,
    user_id              BIGINT       NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    email                VARCHAR(254) NOT NULL UNIQUE,
    is_primary           BOOLEAN      NOT NULL DEFAULT FALSE,
    is_verified          BOOLEAN      NOT NULL DEFAULT FALSE,
    verification_token   VARCHAR(255),
    verification_sent_at TIMESTAMP,
    verified_at          TIMESTAMP,
    created_at           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP
);

-- Normalized phone numbers table
CREATE TABLE user_phone_numbers
(
    id                   BIGSERIAL PRIMARY KEY,
    user_id              BIGINT      NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    phone_number         VARCHAR(16) NOT NULL,
    country_code         VARCHAR(3),
    phone_type           VARCHAR(20) NOT NULL DEFAULT 'PRIMARY',
    is_primary           BOOLEAN     NOT NULL DEFAULT FALSE,
    is_verified          BOOLEAN     NOT NULL DEFAULT FALSE,
    verification_code    VARCHAR(6),
    verification_sent_at TIMESTAMP,
    verified_at          TIMESTAMP,
    created_at           TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP,

    CONSTRAINT chk_phone_type CHECK (phone_type IN ('PRIMARY', 'EMERGENCY', 'WORK', 'HOME')),
    CONSTRAINT chk_verification_code_format CHECK (verification_code IS NULL OR verification_code ~ '^[0-9]{6}$'),
    CONSTRAINT uk_user_phone_numbers_user_phone UNIQUE (user_id, phone_number)
);
CREATE UNIQUE INDEX uk_user_phone_numbers_user_primary
    ON user_phone_numbers (user_id)
    WHERE is_primary = true;

-- User profiles table
CREATE TABLE user_profiles
(
    id               BIGSERIAL PRIMARY KEY,
    user_id          BIGINT    NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    profile_image_id BIGINT,
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- User preferences table (simplified - locale and timezone moved to users table)
CREATE TABLE user_preferences
(
    id                  BIGSERIAL PRIMARY KEY,
    user_id             BIGINT    NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    distance_preference VARCHAR(20)        DEFAULT 'MILES',
    locale              VARCHAR(10)        DEFAULT 'en_US',
    timezone            VARCHAR(50)        DEFAULT 'UTC',
    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_distance_preference CHECK (distance_preference IN ('KILOMETERS', 'MILES'))
);

-- User emergency contacts table (kept for additional emergency contact info beyond phone numbers)
CREATE TABLE user_emergency_contacts
(
    id                BIGSERIAL PRIMARY KEY,
    user_id           BIGINT    NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    emergency_contact VARCHAR(255),
    emergency_phone   VARCHAR(20),
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- User languages table (normalized from ElementCollection)
CREATE TABLE user_languages
(
    id              BIGSERIAL PRIMARY KEY,
    user_profile_id BIGINT       NOT NULL REFERENCES user_profiles (id) ON DELETE CASCADE,
    language        VARCHAR(100) NOT NULL,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (user_profile_id, language)
);

-- Locations table for predefined pickup points
CREATE TABLE locations
(
    id            BIGSERIAL PRIMARY KEY,
    name          VARCHAR(255)          NOT NULL,
    address       VARCHAR(500)          NOT NULL,
    coordinates   GEOMETRY(Point, 4326) NOT NULL,
    location_type VARCHAR(50)           NOT NULL CHECK (location_type IN
                                                        ('AIRPORT', 'CITY_CENTER', 'TRAIN_STATION', 'BUS_STATION',
                                                         'MALL', 'HOTEL', 'UNIVERSITY', 'HOSPITAL',
                                                         'POPULAR_DESTINATION',
                                                         'OTHER')),
    city          VARCHAR(100),
    state         VARCHAR(100),
    country       VARCHAR(100),
    postal_code   VARCHAR(20),
    is_active     BOOLEAN                        DEFAULT true,
    created_at    TIMESTAMP             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP             NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Ride requests table
CREATE TABLE ride_requests
(
    id                    BIGSERIAL PRIMARY KEY,
    trip_id               VARCHAR(255) UNIQUE   NOT NULL,
    rider_id              BIGINT                NOT NULL REFERENCES users (id),
    start_location        GEOMETRY(Point, 4326) NOT NULL,
    start_address         VARCHAR(500),
    end_location          GEOMETRY(Point, 4326) NOT NULL,
    end_address           VARCHAR(500),
    requested_pickup_time TIMESTAMP             NOT NULL,
    number_of_passengers  INTEGER               NOT NULL DEFAULT 1 CHECK (number_of_passengers > 0),
    offer_price           DECIMAL(10, 2),
    status                VARCHAR(50)           NOT NULL DEFAULT 'PENDING' CHECK (status IN
                                                                                  ('PENDING', 'LISTED', 'ACCEPTED',
                                                                                   'PAYMENT_PENDING', 'CONFIRMED',
                                                                                   'IN_PROGRESS', 'COMPLETED',
                                                                                   'CANCELLED', 'LATE', 'DELETED',
                                                                                   'NO_ENOUGH_TIME',
                                                                                   'TOO_MUCH_TIME_AHEAD')),
    notes                 TEXT,
    created_at            TIMESTAMP             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP             NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Ride offers table
CREATE TABLE ride_offers
(
    id                    BIGSERIAL PRIMARY KEY,
    offer_id              VARCHAR(255) UNIQUE NOT NULL,
    driver_id             BIGINT              NOT NULL,
    ride_request_id       BIGINT              NOT NULL REFERENCES ride_requests (id),
    offer_price           DECIMAL(10, 2)      NOT NULL CHECK (offer_price > 0),
    status                VARCHAR(50)         NOT NULL DEFAULT 'PENDING' CHECK (status IN
                                                                                ('PENDING', 'ACCEPTED', 'REJECTED',
                                                                                 'WITHDRAWN', 'EXPIRED', 'CONFIRMED',
                                                                                 'TOO_MANY_REQUESTS', 'GONE')),
    message               TEXT,
    estimated_pickup_time TIMESTAMP,
    created_at            TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Rides table (confirmed rides)
CREATE TABLE rides
(
    id                        BIGSERIAL PRIMARY KEY,
    confirmation_id           VARCHAR(255) UNIQUE NOT NULL,
    arrival_image_document_id BIGINT,
    ride_request_id           BIGINT              NOT NULL REFERENCES ride_requests (id),
    ride_offer_id             BIGINT              NOT NULL REFERENCES ride_offers (id),
    final_price               DECIMAL(10, 2)      NOT NULL,
    status                    VARCHAR(50)         NOT NULL DEFAULT 'CONFIRMED' CHECK (status IN
                                                                                      ('CONFIRMED', 'DRIVER_EN_ROUTE',
                                                                                       'DRIVER_ARRIVED', 'IN_PROGRESS',
                                                                                       'COMPLETED', 'CANCELLED', 'LATE',
                                                                                       'NO_SHOW')),
    scheduled_pickup_time     TIMESTAMP,
    actual_pickup_time        TIMESTAMP,
    dropoff_time              TIMESTAMP,
    driver_current_location   GEOMETRY(Point, 4326),
    driver_arrival_time       TIMESTAMP,
    cancellation_reason       TEXT,
    completion_notes          TEXT,
    created_at                TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Ratings table
CREATE TABLE ratings
(
    id          BIGSERIAL PRIMARY KEY,
    ride_id     BIGINT           NOT NULL REFERENCES rides (id),
    rater_id    BIGINT           NOT NULL REFERENCES users (id),
    rated_id    BIGINT           NOT NULL REFERENCES users (id),
    rating      DOUBLE PRECISION NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment     TEXT,
    rating_type VARCHAR(20)      NOT NULL CHECK (rating_type IN ('RIDER', 'DRIVER', 'SYSTEM_DEFAULT')),
    created_at  TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP                 DEFAULT CURRENT_TIMESTAMP,

    -- Ensure one rating per user per ride per type
    UNIQUE (ride_id, rater_id, rating_type)
);

-- Create indexes for performance
-- Users table indexes
CREATE INDEX idx_users_is_active ON users (is_active);
CREATE INDEX idx_users_date_of_birth ON users (date_of_birth);
CREATE INDEX idx_users_last_login_at ON users (last_login_at);

-- User authentication indexes
CREATE INDEX idx_user_auth_user_id ON user_authentication (user_id);
CREATE INDEX idx_user_auth_auth0_id ON user_authentication (auth0_id);
CREATE INDEX idx_user_auth_keycloak_id ON user_authentication (keycloak_id);
CREATE INDEX idx_user_auth_provider ON user_authentication (auth_provider);

-- Contact information indexes
CREATE INDEX idx_user_emails_user_id ON user_emails (user_id);
CREATE INDEX idx_user_emails_email ON user_emails (email);
CREATE INDEX idx_user_emails_is_primary ON user_emails (user_id, is_primary);
CREATE INDEX idx_user_emails_verification_token ON user_emails (verification_token);
CREATE INDEX idx_user_emails_is_verified ON user_emails (user_id, is_verified);

CREATE INDEX idx_user_phone_numbers_user_id ON user_phone_numbers (user_id);
CREATE INDEX idx_user_phone_numbers_phone_number ON user_phone_numbers (phone_number);
CREATE INDEX idx_user_phone_numbers_is_primary ON user_phone_numbers (user_id, is_primary);
CREATE INDEX idx_user_phone_numbers_phone_type ON user_phone_numbers (user_id, phone_type);
CREATE INDEX idx_user_phone_numbers_verification_code ON user_phone_numbers (verification_code);
CREATE INDEX idx_user_phone_numbers_is_verified ON user_phone_numbers (is_verified);

-- User profiles indexes
CREATE INDEX idx_user_profiles_user_id ON user_profiles (user_id);
CREATE INDEX idx_user_profiles_image_id ON user_profiles (profile_image_id);

-- User preferences indexes
CREATE INDEX idx_user_preferences_user_id ON user_preferences (user_id);

-- User emergency contacts indexes
CREATE INDEX idx_user_emergency_user_id ON user_emergency_contacts (user_id);

-- User languages indexes
CREATE INDEX idx_user_languages_profile_id ON user_languages (user_profile_id);
CREATE INDEX idx_user_languages_language ON user_languages (language);

-- Ride requests indexes
CREATE INDEX idx_ride_requests_trip_id ON ride_requests (trip_id);
CREATE INDEX idx_ride_requests_rider_status ON ride_requests (rider_id, status);
CREATE INDEX idx_ride_requests_start_location ON ride_requests USING GIST (start_location);
CREATE INDEX idx_ride_requests_end_location ON ride_requests USING GIST (end_location);
CREATE INDEX idx_ride_requests_status_time ON ride_requests (status, requested_pickup_time);

-- Ride offers indexes
CREATE INDEX idx_ride_offers_offer_id ON ride_offers (offer_id);
CREATE INDEX idx_ride_offers_driver_status ON ride_offers (driver_id, status);
CREATE INDEX idx_ride_offers_request_status ON ride_offers (ride_request_id, status);

-- Rides indexes
CREATE INDEX idx_rides_confirmation_id ON rides (confirmation_id);
CREATE INDEX idx_rides_status ON rides (status);
CREATE INDEX idx_rides_dropoff_time ON rides (dropoff_time);

-- Locations indexes
CREATE INDEX idx_locations_coordinates ON locations USING GIST (coordinates);
CREATE INDEX idx_locations_type_active ON locations (location_type, is_active);

-- Ratings indexes
CREATE INDEX idx_ratings_ride_rater ON ratings (ride_id, rater_id);
CREATE INDEX idx_ratings_rated_type ON ratings (rated_id, rating_type);

-- Add unique constraints to ensure data integrity
ALTER TABLE user_authentication
    ADD CONSTRAINT uk_user_auth_user_id UNIQUE (user_id);
ALTER TABLE user_authentication
    ADD CONSTRAINT unique_auth_provider_id
        UNIQUE (auth_provider, auth0_id, keycloak_id);
ALTER TABLE user_profiles
    ADD CONSTRAINT uk_user_profiles_user_id UNIQUE (user_id);
ALTER TABLE user_preferences
    ADD CONSTRAINT uk_user_preferences_user_id UNIQUE (user_id);
ALTER TABLE user_emergency_contacts
    ADD CONSTRAINT uk_user_emergency_user_id UNIQUE (user_id);

-- Contact information unique constraints
-- Ensure at most one primary email per user
CREATE UNIQUE INDEX idx_users_one_primary_email
    ON user_emails (user_id) WHERE is_primary = true;

-- Ensure at most one primary phone per user
CREATE UNIQUE INDEX idx_users_one_primary_phone
    ON user_phone_numbers (user_id) WHERE is_primary = true;

-- Add triggers to automatically update updated_at timestamps
CREATE
    OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_at
        = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$
    language 'plpgsql';

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE
    ON users
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_authentication_updated_at
    BEFORE UPDATE
    ON user_authentication
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_emails_updated_at
    BEFORE UPDATE
    ON user_emails
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_phone_numbers_updated_at
    BEFORE UPDATE
    ON user_phone_numbers
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE
    ON user_profiles
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_preferences_updated_at
    BEFORE UPDATE
    ON user_preferences
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_emergency_contacts_updated_at
    BEFORE UPDATE
    ON user_emergency_contacts
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

