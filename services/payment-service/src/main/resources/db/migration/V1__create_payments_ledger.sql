-- Immutable payments ledger — append-only, no updates
CREATE TABLE IF NOT EXISTS payments_ledger (
    id                BIGSERIAL PRIMARY KEY,
    transaction_id    UUID        NOT NULL UNIQUE,
    order_id          VARCHAR(64) NOT NULL,
    amount            NUMERIC(12,2) NOT NULL,
    currency          VARCHAR(3)  NOT NULL DEFAULT 'INR',
    status            VARCHAR(32) NOT NULL DEFAULT 'PENDING',
    payment_method    VARCHAR(32) NOT NULL,
    gateway_ref       VARCHAR(255),
    created_at        TIMESTAMP   NOT NULL DEFAULT NOW(),
    processed_at      TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_payments_order ON payments_ledger(order_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments_ledger(status);

-- Refunds table (related but separate)
CREATE TABLE IF NOT EXISTS refunds (
    id                BIGSERIAL PRIMARY KEY,
    transaction_id    UUID        NOT NULL REFERENCES payments_ledger(transaction_id),
    refund_amount     NUMERIC(12,2) NOT NULL,
    reason            VARCHAR(255),
    created_at        TIMESTAMP   NOT NULL DEFAULT NOW(),
    status            VARCHAR(32) NOT NULL DEFAULT 'PENDING'
);
