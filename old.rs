// Transpiled from Solidity using charcoal. Generated code may be incorrect or unoptimal.
contract;

use std::hash::Hash;


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

struct Sign {
    v: u8,
    r: b256,
    s: b256,
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
    fn constructor(signer: Identity, admin: Identity);

    #[storage(read)]
    fn fills(a: b256) -> bool;

    #[storage(read)]
    fn is_signer_wallet(a: Identity) -> bool;

    #[storage(read)]
    fn is_relayer_wallet(a: Identity) -> bool;

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

impl CricSageStore for Contract {
    #[storage(read, write)]
    fn constructor(signer: Identity, admin: Identity) {
        require(!storage.cric_sage_store_constructor_called.read(), "The CricSageStore constructor has already been called");
        storage.cric_sage_store_constructor_called.write(true);
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

    #[storage(read, write)]
    fn add_whitelist(erc_20_address: Identity) -> bool {
        require(!storage.whitelisted_address.get(erc_20_address).read(), "Address is already whitelisted");
        storage.whitelisted_address.get(erc_20_address).write(true);
        log(CricSageStoreEvent::AddedToWhitelist(erc_20_address));
        true
    }

    #[storage(read, write)]
    fn remove_whitelist(erc_20_address: Identity) -> bool {
        require(storage.whitelisted_address.get(erc_20_address).read(), "Address is not whitelisted");
        storage.whitelisted_address.get(erc_20_address).write(false);
        log(CricSageStoreEvent::RemovedFromWhitelist(erc_20_address));
        true
    }

    #[storage(read, write)]
    fn set_relayer(accounts: Vec<Identity>) {
        let mut i = 0;
        while i < accounts.len() {
            storage.is_relayer_wallet.get(accounts.get(i).unwrap()).write(true);
            i += 1;
        }
    }

    #[storage(read, write)]
    fn execute_order_by_relayer(order: Order) {
        require(storage.is_relayer_wallet.get(msg_sender().unwrap()).read(), "Caller is not a relayer");
        _execute_order(order);
    }

    #[storage(read, write)]
    fn execute_order_by_buyer(order: Order) {
        require(order.buyer == msg_sender().unwrap(), "Buyer and sender should be same");
        _execute_order(order);
    }

    #[storage(read, write)]
    fn execute_order_by_mint_and_buy(order: Order) {
        require(order.buyer == msg_sender().unwrap(), "Buyer and sender should be same");
        _execute_order_by_mint(order);
    }
}

