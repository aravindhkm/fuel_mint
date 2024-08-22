// Transpiled from Solidity using charcoal. Generated code may be incorrect or unoptimal.
contract;

mod errors;

use std::{
    asset::transfer,
    auth::msg_sender,
    block::height,
    call_frames::msg_asset_id,
    context::{
        msg_amount,
        this_balance,
    },
    hash::{
        Hash,
        sha256,
    },
    intrinsics::size_of_val,
};

pub enum CState {
    /// The contract has not been initialized.
    NotInitialized: (),
    /// The contract has been initialized.
    Initialized: (),
}

use standards::{src20::SRC20, src3::SRC3, src5::{SRC5, State},};
use ::errors::{InitializationError};

use sway_libs::{
    asset::{
        base::{
            _decimals,
            _name,
            _set_decimals,
            _set_name,
            _set_symbol,
            _symbol,
            _total_assets,
            _total_supply,
            SetAssetAttributes,
        },
        supply::{
            _burn,
            _mint,
        },
    },
    ownership::{
        _owner,
        initialize_ownership,
        only_owner,
    },
    pausable::{
        _is_paused,
        _pause,
        _unpause,
        Pausable,
        require_not_paused,
        require_paused,
    },
};

struct Order {
    seller: Identity,
    admin: Identity,
    buyer: Identity,
    asset: Identity,
    payment_token: Identity,
    token_id: u256,
    supply: u256,
    price: u256,
    expiration_time: u256,
    salt: u256,
    question_id: str,
    token_uri: str,
    side: bool,
}

enum CricSageStoreEvent {
    AddedToWhitelist: Identity,
    RemovedFromWhitelist: Identity,
    mintandBuyOrderExecuted: (Identity, Identity, Identity, Identity, u256, u256, u256, str, bool),
    OrderExecuted: (Identity, Identity, Identity, Identity, u256, u256, u256),
}

impl AbiEncode for CricSageStoreEvent {
    fn abi_encode(self, buffer: Buffer) -> Buffer {
        let buffer = match self {
            CricSageStoreEvent::AddedToWhitelist(a) => {
                match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                }
            },
            CricSageStoreEvent::RemovedFromWhitelist(a) => {
                match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                }
            },
            CricSageStoreEvent::mintandBuyOrderExecuted((a, b, c, d, e, f, g, h, i)) => {
                let buffer = match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match b {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match c {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match d {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = e.abi_encode(buffer);
                let buffer = f.abi_encode(buffer);
                let buffer = g.abi_encode(buffer);
                let buffer = h.abi_encode(buffer);
                let buffer = i.abi_encode(buffer);
                buffer
            },
            CricSageStoreEvent::OrderExecuted((a, b, c, d, e, f, g)) => {
                let buffer = match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match b {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match c {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match d {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = e.abi_encode(buffer);
                let buffer = f.abi_encode(buffer);
                let buffer = g.abi_encode(buffer);
                buffer
            },
        };
        buffer
    }
}

abi CricSageStore {
    #[storage(read, write)]
    fn constructor(signer: Identity, admin: Identity, asset: AssetId );

    #[storage(read)]
    fn fills(a: b256) -> bool;

    #[storage(read)]
    fn is_signer_wallet(a: Identity) -> bool;

    #[storage(read)]
    fn is_relayer_wallet(a: Identity) -> bool;

    #[storage(read, write)]
    fn claim(amount: u64, to: Identity) -> bool;

    #[storage(read)]
    fn get_asset_id() -> AssetId;

    #[storage(read)]
    fn get_asset_balance() -> u64;

    #[storage(read)]
    fn get_asset_balance_two(asset_id: AssetId) -> u64;

    #[storage(read)]
    fn get_asset_balance_all() -> u64;

    #[storage(read, write)]
    fn add_whitelist(erc_20_address: Identity) -> bool;

    #[storage(read, write)]
    fn remove_whitelist(erc_20_address: Identity) -> bool;

    #[storage(read, write)]
    fn set_relayer(accounts: Vec<Identity>);

    #[storage(read, write)]
    fn execute_order_by_relayer(order: Order);

    #[storage(read, write)]
    fn execute_order_by_buyer(order: Order);

    #[storage(read, write)]
    fn execute_order_by_mint_and_buy(order: Order);
}

storage {
    fills: StorageMap<b256, bool> = StorageMap {},
    whitelisted_address: StorageMap<Identity, bool> = StorageMap {},
    is_signer_wallet: StorageMap<Identity, bool> = StorageMap {},
    is_relayer_wallet: StorageMap<Identity, bool> = StorageMap {},
    cric_sage_store_constructor_called: bool = false,
    /// AssetId of the governance asset
    asset: AssetId = AssetId::zero(),
    cstate: CState = CState::NotInitialized,
}

#[storage(read, write)]
fn _execute_order(order: Order) {
    require(storage.whitelisted_address.get(order.payment_token).read(), "Not whitelisted address");
    require(order.expiration_time != 0 && order.expiration_time >= std::block::timestamp().as_u256(), "Order Expired");
    log(CricSageStoreEvent::OrderExecuted((order.asset, order.admin, order.buyer, order.payment_token, order.token_id, order.supply, order.price)));
}

#[storage(read, write)]
fn _execute_order_by_mint(order: Order) {
    require(storage.whitelisted_address.get(order.payment_token).read(), "Not whitelisted address");
    require(order.expiration_time != 0 && order.expiration_time >= std::block::timestamp().as_u256(), "Order Expired");
    log(CricSageStoreEvent::mintandBuyOrderExecuted((order.asset, order.admin, order.buyer, order.payment_token, order.token_id, order.supply, order.price, order.question_id, order.side)));
}


impl SRC5 for Contract {
    /// Returns the owner.
    ///
    /// # Return Values
    ///
    /// * [State] - Represents the state of ownership for this contract.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Reads: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use standards::src5::SRC5;
    ///
    /// fn foo(contract_id: ContractId) {
    ///     let ownership_abi = abi(contract_id, SRC_5);
    ///
    ///     match ownership_abi.owner() {
    ///         State::Uninitalized => log("The ownership is uninitalized"),
    ///         _ => log("This example will never reach this statement"),
    ///     }
    /// }
    /// ```
    #[storage(read)]
    fn owner() -> State {
        _owner()
    }
}

impl Pausable for Contract {
    /// Pauses the contract.
    ///
    /// # Reverts
    ///
    /// * When the caller is not the contract owner.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Writes: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::pausable::Pausable;
    ///
    /// fn foo(contract_id: ContractId) {
    ///     let pausable_abi = abi(Pausable, contract_id);
    ///     pausable_abi.pause();
    ///     assert(pausable_abi.is_paused());
    /// }
    /// ```
    #[storage(write)]
    fn pause() {
        only_owner();
        _pause();
    }

    /// Returns whether the contract is paused.
    ///
    /// # Returns
    ///
    /// * [bool] - The pause state for the contract.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Reads: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::pausable::Pausable;
    ///
    /// fn foo(contract_id: ContractId) {
    ///     let pausable_abi = abi(Pausable, contract_id);
    ///     assert(!pausable_abi.is_paused());
    /// }
    /// ```
    #[storage(read)]
    fn is_paused() -> bool {
        _is_paused()
    }

    /// Unpauses the contract.
    ///
    /// # Reverts
    ///
    /// * When the caller is not the contract owner.
    ///
    /// # Number of Storage Accesses
    ///
    /// * Writes: `1`
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::pausable::Pausable;
    ///
    /// fn foo(contract_id: ContractId) {
    ///     let pausable_abi = abi(Pausable, contract_id);
    ///     pausable_abi.unpause();
    ///     assert(!pausable_abi.is_paused());
    /// }
    /// ```
    #[storage(write)]
    fn unpause() {
        only_owner();
        _unpause();
    }
}

impl CricSageStore for Contract {
    #[storage(read, write)]
    fn constructor(signer: Identity, admin: Identity, asset: AssetId,) {
        require(!storage.cric_sage_store_constructor_called.read(), "The CricSageStore constructor has already been called");
        storage.cric_sage_store_constructor_called.write(true);
        initialize_ownership(admin);
        storage.asset.write(asset);
    }

    #[storage(read)]
    fn fills(a: b256) -> bool {
        storage.fills.get(a).read()
    }

    #[storage(read)]
    fn is_signer_wallet(a: Identity) -> bool {
        storage.is_signer_wallet.get(a).read()
    }

    #[storage(read)]
    fn is_relayer_wallet(a: Identity) -> bool {
        storage.is_relayer_wallet.get(a).read()
    }

    #[storage(read)]
    fn get_asset_id() -> AssetId {
        storage.asset.read()
    }

    #[storage(read)]
    fn get_asset_balance() -> u64 {
        this_balance(storage.asset.read())
    }

    #[storage(read)]
    fn get_asset_balance_two(asset_id: AssetId) -> u64 {
        this_balance(asset_id)
    }

    #[storage(read)]
    fn get_asset_balance_all() -> u64 {
        this_balance(AssetId::base())
    }

    #[storage(read, write)]
    fn claim(amount: u64, to: Identity) -> bool {
        let asset = storage.asset.read();
        let balance = this_balance(asset);
        transfer(to, asset, balance);
        true
    }

    #[storage(read, write)]
    fn add_whitelist(erc_20_address: Identity) -> bool {
        only_owner();

        require(!storage.whitelisted_address.get(erc_20_address).read(), "Address is already whitelisted");
        storage.whitelisted_address.get(erc_20_address).write(true);
        log(CricSageStoreEvent::AddedToWhitelist(erc_20_address));
        true
    }

    #[storage(read, write)]
    fn remove_whitelist(erc_20_address: Identity) -> bool {
        only_owner();

        require(storage.whitelisted_address.get(erc_20_address).read(), "Address is not whitelisted");
        storage.whitelisted_address.get(erc_20_address).write(false);
        log(CricSageStoreEvent::RemovedFromWhitelist(erc_20_address));
        true
    }

    #[storage(read, write)]
    fn set_relayer(accounts: Vec<Identity>) {
        only_owner();

        let mut i = 0;
        while i < accounts.len() {
            storage.is_relayer_wallet.get(accounts.get(i).unwrap()).write(true);
            i += 1;
        }
    }

    #[storage(read, write)]
    fn execute_order_by_relayer(order: Order) {
        only_owner();
        require_not_paused();

        require(storage.is_relayer_wallet.get(msg_sender().unwrap()).read(), "Caller is not a relayer");
        _execute_order(order);
    }

    #[storage(read, write)]
    fn execute_order_by_buyer(order: Order) {
        only_owner();
        require_not_paused();

        require(order.buyer == msg_sender().unwrap(), "Buyer and sender should be same");
        _execute_order(order);
    }

    #[storage(read, write)]
    fn execute_order_by_mint_and_buy(order: Order) {
        only_owner();
        require_not_paused();

        require(order.buyer == msg_sender().unwrap(), "Buyer and sender should be same");
        _execute_order_by_mint(order);
    }
}

