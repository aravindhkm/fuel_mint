library;

pub enum AmountError {
    AmountMismatch: (),
}

pub enum MintError {
    MaxMinted: (),
}

pub enum SetError {
    ValueAlreadySet: (),
}

/// Errors related to initialization of the contract.
pub enum InitializationError {
    /// The contract has already been initialized.
    CannotReinitialize: (),
    /// The contract has not been initialized.
    ContractNotInitialized: (),
}