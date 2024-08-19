// Transpiled from Solidity using charcoal. Generated code may be incorrect or unoptimal.
contract;

use std::bytes::Bytes;

#[storage(read)]
fn context__msg_sender() -> Identity {
    msg_sender().unwrap()
}

#[storage(read)]
fn context__msg_data() -> Bytes {
    std::inputs::input_message_data(0, 0)
}

// Transpiled from Solidity using charcoal. Generated code may be incorrect or unoptimal.
contract;

use std::bytes::Bytes;
use std::constants::ZERO_B256;

enum OwnableEvent {
    OwnershipTransferred: (Identity, Identity),
}

impl AbiEncode for OwnableEvent {
    fn abi_encode(self, buffer: Buffer) -> Buffer {
        let buffer = match self {
            OwnableEvent::OwnershipTransferred((a, b)) => {
                let buffer = match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match b {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                buffer
            },
        };
        buffer
    }
}

abi Ownable {
    #[storage(read, write)]
    fn constructor();

    #[storage(read)]
    fn owner() -> Identity;

    #[storage(read, write)]
    fn renounce_ownership();

    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity);
}

storage {
    _owner: Identity = Identity::Address(Address::from(ZERO_B256)),
    ownable_constructor_called: bool = false,
}

#[storage(read)]
fn context__msg_sender() -> Identity {
    msg_sender().unwrap()
}

#[storage(read)]
fn context__msg_data() -> Bytes {
    std::inputs::input_message_data(0, 0)
}

fn only_owner() {
    ownable__check_owner();
}

#[storage(read, write)]
fn ownable_constructor() {
    require(!storage.ownable_constructor_called.read(), "The Ownable constructor has already been called");
    ownable__transfer_ownership(context__msg_sender());
    storage.ownable_constructor_called.write(true);
}

#[storage(read)]
fn ownable_owner() -> Identity {
    storage._owner.read()
}

#[storage(read)]
fn ownable__check_owner() {
    require(ownable_owner() == context__msg_sender(), "Ownable: caller is not the owner");
}

#[storage(read, write)]
fn ownable_renounce_ownership() {
    only_owner();
    ownable__transfer_ownership(Identity::Address(Address::from(ZERO_B256)));
}

#[storage(read, write)]
fn ownable_transfer_ownership(new_owner: Identity) {
    only_owner();
    require(new_owner != Identity::Address(Address::from(ZERO_B256)), "Ownable: new owner is the zero address");
    ownable__transfer_ownership(new_owner);
}

#[storage(read, write)]
fn ownable__transfer_ownership(new_owner: Identity) {
    let old_owner = storage._owner.read();
    storage._owner.write(new_owner);
    log(OwnableEvent::OwnershipTransferred((old_owner, new_owner)));
}

impl Ownable for Contract {
    #[storage(read, write)]
    fn constructor() {
        ::ownable_constructor()
    }

    #[storage(read)]
    fn owner() -> Identity {
        ::ownable_owner()
    }

    #[storage(read, write)]
    fn renounce_ownership() {
        ::ownable_renounce_ownership()
    }

    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity) {
        ::ownable_transfer_ownership(new_owner)
    }
}

// Transpiled from Solidity using charcoal. Generated code may be incorrect or unoptimal.
contract;

enum IERC20Event {
    Transfer: (Identity, Identity, u256),
    Approval: (Identity, Identity, u256),
}

impl AbiEncode for IERC20Event {
    fn abi_encode(self, buffer: Buffer) -> Buffer {
        let buffer = match self {
            IERC20Event::Transfer((a, b, c)) => {
                let buffer = match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match b {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = c.abi_encode(buffer);
                buffer
            },
            IERC20Event::Approval((a, b, c)) => {
                let buffer = match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match b {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = c.abi_encode(buffer);
                buffer
            },
        };
        buffer
    }
}

abi IERC20 {
    #[storage(read)]
    fn total_supply() -> u256;

    #[storage(read)]
    fn balance_of(account: Identity) -> u256;

    #[storage(read, write)]
    fn transfer(to: Identity, amount: u256) -> bool;

    #[storage(read)]
    fn allowance(owner: Identity, spender: Identity) -> u256;

    #[storage(read, write)]
    fn approve(spender: Identity, amount: u256) -> bool;

    #[storage(read, write)]
    fn transfer_from(from: Identity, to: Identity, amount: u256) -> bool;
}

// Transpiled from Solidity using charcoal. Generated code may be incorrect or unoptimal.
contract;

use std::bytes::Bytes;

enum PausableEvent {
    Paused: Identity,
    Unpaused: Identity,
}

impl AbiEncode for PausableEvent {
    fn abi_encode(self, buffer: Buffer) -> Buffer {
        let buffer = match self {
            PausableEvent::Paused(a) => {
                match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                }
            },
            PausableEvent::Unpaused(a) => {
                match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                }
            },
        };
        buffer
    }
}

abi Pausable {
    #[storage(read, write)]
    fn constructor();

    #[storage(read)]
    fn paused() -> bool;
}

storage {
    _paused: bool = false,
    pausable_constructor_called: bool = false,
}

#[storage(read)]
fn context__msg_sender() -> Identity {
    msg_sender().unwrap()
}

#[storage(read)]
fn context__msg_data() -> Bytes {
    std::inputs::input_message_data(0, 0)
}

fn when_not_paused() {
    pausable__require_not_paused();
}

fn when_paused() {
    pausable__require_paused();
}

#[storage(read, write)]
fn pausable_constructor() {
    require(!storage.pausable_constructor_called.read(), "The Pausable constructor has already been called");
    storage._paused.write(false);
    storage.pausable_constructor_called.write(true);
}

#[storage(read)]
fn pausable_paused() -> bool {
    storage._paused.read()
}

#[storage(read)]
fn pausable__require_not_paused() {
    require(!pausable_paused(), "Pausable: paused");
}

#[storage(read)]
fn pausable__require_paused() {
    require(pausable_paused(), "Pausable: not paused");
}

#[storage(read, write)]
fn pausable__pause() {
    when_not_paused();
    storage._paused.write(true);
    log(PausableEvent::Paused(context__msg_sender()));
}

#[storage(read, write)]
fn pausable__unpause() {
    when_paused();
    storage._paused.write(false);
    log(PausableEvent::Unpaused(context__msg_sender()));
}

impl Pausable for Contract {
    #[storage(read, write)]
    fn constructor() {
        ::pausable_constructor()
    }

    #[storage(read)]
    fn paused() -> bool {
        ::pausable_paused()
    }
}

// Transpiled from Solidity using charcoal. Generated code may be incorrect or unoptimal.
contract;

abi IERC165 {
    #[storage(read)]
    fn supports_interface(interface_id: [u8; 4]) -> bool;
}

// Transpiled from Solidity using charcoal. Generated code may be incorrect or unoptimal.
contract;

use std::bytes::Bytes;

enum IERC1155Event {
    TransferSingle: (Identity, Identity, Identity, u256, u256),
    TransferBatch: (Identity, Identity, Identity, Vec<u256>, Vec<u256>),
    ApprovalForAll: (Identity, Identity, bool),
    URI: (str, u256),
}

impl AbiEncode for IERC1155Event {
    fn abi_encode(self, buffer: Buffer) -> Buffer {
        let buffer = match self {
            IERC1155Event::TransferSingle((a, b, c, d, e)) => {
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
                let buffer = d.abi_encode(buffer);
                let buffer = e.abi_encode(buffer);
                buffer
            },
            IERC1155Event::TransferBatch((a, b, c, d, e)) => {
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
                let buffer = d.abi_encode(buffer);
                let buffer = e.abi_encode(buffer);
                buffer
            },
            IERC1155Event::ApprovalForAll((a, b, c)) => {
                let buffer = match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match b {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = c.abi_encode(buffer);
                buffer
            },
            IERC1155Event::URI((a, b)) => {
                let buffer = a.abi_encode(buffer);
                let buffer = b.abi_encode(buffer);
                buffer
            },
        };
        buffer
    }
}

abi IERC1155 {
    #[storage(read)]
    fn supports_interface(interface_id: [u8; 4]) -> bool;

    #[storage(read)]
    fn balance_of(account: Identity, id: u256) -> u256;

    #[storage(read)]
    fn balance_of_batch(accounts: Vec<Identity>, ids: Vec<u256>) -> Vec<u256>;

    #[storage(read, write)]
    fn set_approval_for_all(operator: Identity, approved: bool);

    #[storage(read)]
    fn is_approved_for_all(account: Identity, operator: Identity) -> bool;

    #[storage(read, write)]
    fn safe_transfer_from(from: Identity, to: Identity, id: u256, amount: u256, data: Bytes);

    #[storage(read, write)]
    fn safe_batch_transfer_from(from: Identity, to: Identity, ids: Vec<u256>, amounts: Vec<u256>, data: Bytes);
}

// Transpiled from Solidity using charcoal. Generated code may be incorrect or unoptimal.
contract;

use std::bytes::Bytes;

enum IERC1155Event {
    TransferSingle: (Identity, Identity, Identity, u256, u256),
    TransferBatch: (Identity, Identity, Identity, Vec<u256>, Vec<u256>),
    ApprovalForAll: (Identity, Identity, bool),
    URI: (str, u256),
}

impl AbiEncode for IERC1155Event {
    fn abi_encode(self, buffer: Buffer) -> Buffer {
        let buffer = match self {
            IERC1155Event::TransferSingle((a, b, c, d, e)) => {
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
                let buffer = d.abi_encode(buffer);
                let buffer = e.abi_encode(buffer);
                buffer
            },
            IERC1155Event::TransferBatch((a, b, c, d, e)) => {
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
                let buffer = d.abi_encode(buffer);
                let buffer = e.abi_encode(buffer);
                buffer
            },
            IERC1155Event::ApprovalForAll((a, b, c)) => {
                let buffer = match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match b {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = c.abi_encode(buffer);
                buffer
            },
            IERC1155Event::URI((a, b)) => {
                let buffer = a.abi_encode(buffer);
                let buffer = b.abi_encode(buffer);
                buffer
            },
        };
        buffer
    }
}

abi ISAGE1155 {
    #[storage(read)]
    fn supports_interface(interface_id: [u8; 4]) -> bool;

    #[storage(read)]
    fn balance_of(account: Identity, id: u256) -> u256;

    #[storage(read)]
    fn balance_of_batch(accounts: Vec<Identity>, ids: Vec<u256>) -> Vec<u256>;

    #[storage(read, write)]
    fn set_approval_for_all(operator: Identity, approved: bool);

    #[storage(read)]
    fn is_approved_for_all(account: Identity, operator: Identity) -> bool;

    #[storage(read, write)]
    fn safe_transfer_from(from: Identity, to: Identity, id: u256, amount: u256, data: Bytes);

    #[storage(read, write)]
    fn safe_batch_transfer_from(from: Identity, to: Identity, ids: Vec<u256>, amounts: Vec<u256>, data: Bytes);

    #[storage(read, write)]
    fn safe_mint(account: Identity, id: u256, supply: u256, cid: str) -> bool;

    #[storage(read, write)]
    fn safe_mint_supply(account: Identity, id: u256, supply: u256, question_id: str, side: bool) -> bool;
}

// Transpiled from Solidity using charcoal. Generated code may be incorrect or unoptimal.
contract;

use std::bytes::Bytes;
use std::constants::ZERO_B256;
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

enum PausableEvent {
    Paused: Identity,
    Unpaused: Identity,
}

impl AbiEncode for PausableEvent {
    fn abi_encode(self, buffer: Buffer) -> Buffer {
        let buffer = match self {
            PausableEvent::Paused(a) => {
                match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                }
            },
            PausableEvent::Unpaused(a) => {
                match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                }
            },
        };
        buffer
    }
}

enum OwnableEvent {
    OwnershipTransferred: (Identity, Identity),
}

impl AbiEncode for OwnableEvent {
    fn abi_encode(self, buffer: Buffer) -> Buffer {
        let buffer = match self {
            OwnableEvent::OwnershipTransferred((a, b)) => {
                let buffer = match a {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                let buffer = match b {
                    Identity::Address(x) => x.abi_encode(buffer),
                    Identity::ContractId(x) => x.abi_encode(buffer),
                };
                buffer
            },
        };
        buffer
    }
}

enum CricSageStoreEvent {
    AddedToWhitelist: Identity,
    RemovedFromWhitelist: Identity,
    mintandBuyOrderExecuted: (Identity, Identity, Identity, Identity, u256, u256, u256, str, bool, b256),
    OrderExecuted: (Identity, Identity, Identity, Identity, u256, u256, u256, b256),
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
            CricSageStoreEvent::mintandBuyOrderExecuted((a, b, c, d, e, f, g, h, i, j)) => {
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
                let buffer = j.abi_encode(buffer);
                buffer
            },
            CricSageStoreEvent::OrderExecuted((a, b, c, d, e, f, g, h)) => {
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
    fn paused() -> bool;

    #[storage(read)]
    fn owner() -> Identity;

    #[storage(read, write)]
    fn renounce_ownership();

    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity);

    #[storage(read)]
    fn fills(a: b256) -> bool;

    #[storage(read)]
    fn is_signer_wallet(a: Identity) -> bool;

    #[storage(read)]
    fn is_relayer_wallet(a: Identity) -> bool;

    #[storage(read, write)]
    fn pause();

    #[storage(read, write)]
    fn unpause();

    #[storage(read, write)]
    fn add_whitelist(erc_20_address: Identity) -> bool;

    #[storage(read, write)]
    fn remove_whitelist(erc_20_address: Identity) -> bool;

    #[storage(read, write)]
    fn set_relayer(accounts: Vec<Identity>);

    #[storage(read, write)]
    fn execute_order_by_relayer(order: Order, sign: Sign);

    #[storage(read, write)]
    fn execute_order_by_buyer(order: Order, sign: Sign);

    #[storage(read, write)]
    fn execute_order_by_mint_and_buy(order: Order, sign: Sign);

    fn hash_order_primary(order: Order) -> b256;

    fn hash_order(order: Order) -> b256;

    fn hash_mint_and_execute_order(celebrity_address: Identity, token_uri: str, order: Order) -> b256;
}

storage {
    _paused: bool = false,
    pausable_constructor_called: bool = false,
    _owner: Identity = Identity::Address(Address::from(ZERO_B256)),
    ownable_constructor_called: bool = false,
    fills: StorageMap<b256, bool> = StorageMap {},
    whitelisted_address: StorageMap<Identity, bool> = StorageMap {},
    is_signer_wallet: StorageMap<Identity, bool> = StorageMap {},
    is_relayer_wallet: StorageMap<Identity, bool> = StorageMap {},
    cric_sage_store_constructor_called: bool = false,
}

#[storage(read)]
fn context__msg_sender() -> Identity {
    msg_sender().unwrap()
}

#[storage(read)]
fn context__msg_data() -> Bytes {
    std::inputs::input_message_data(0, 0)
}

fn when_not_paused() {
    pausable__require_not_paused();
}

fn when_paused() {
    pausable__require_paused();
}

#[storage(read, write)]
fn pausable_constructor() {
    require(!storage.pausable_constructor_called.read(), "The Pausable constructor has already been called");
    storage._paused.write(false);
    storage.pausable_constructor_called.write(true);
}

#[storage(read)]
fn pausable_paused() -> bool {
    storage._paused.read()
}

#[storage(read)]
fn pausable__require_not_paused() {
    require(!pausable_paused(), "Pausable: paused");
}

#[storage(read)]
fn pausable__require_paused() {
    require(pausable_paused(), "Pausable: not paused");
}

#[storage(read, write)]
fn pausable__pause() {
    when_not_paused();
    storage._paused.write(true);
    log(PausableEvent::Paused(context__msg_sender()));
}

#[storage(read, write)]
fn pausable__unpause() {
    when_paused();
    storage._paused.write(false);
    log(PausableEvent::Unpaused(context__msg_sender()));
}

#[storage(read, write)]
fn pausable_constructor() {
    ::pausable_constructor()
}

fn only_owner() {
    ownable__check_owner();
}

#[storage(read, write)]
fn ownable_constructor() {
    require(!storage.ownable_constructor_called.read(), "The Ownable constructor has already been called");
    ownable__transfer_ownership(context__msg_sender());
    storage.ownable_constructor_called.write(true);
}

#[storage(read)]
fn ownable_owner() -> Identity {
    storage._owner.read()
}

#[storage(read)]
fn ownable__check_owner() {
    require(ownable_owner() == context__msg_sender(), "Ownable: caller is not the owner");
}

#[storage(read, write)]
fn ownable_renounce_ownership() {
    only_owner();
    ownable__transfer_ownership(Identity::Address(Address::from(ZERO_B256)));
}

#[storage(read, write)]
fn ownable_transfer_ownership(new_owner: Identity) {
    only_owner();
    require(new_owner != Identity::Address(Address::from(ZERO_B256)), "Ownable: new owner is the zero address");
    ownable__transfer_ownership(new_owner);
}

#[storage(read, write)]
fn ownable__transfer_ownership(new_owner: Identity) {
    let old_owner = storage._owner.read();
    storage._owner.write(new_owner);
    log(OwnableEvent::OwnershipTransferred((old_owner, new_owner)));
}

#[storage(read, write)]
fn ownable_constructor() {
    ::ownable_constructor()
}

fn hash_order_primary(order: Order) -> b256 {
    std::hash::keccak256({
        let mut bytes = Bytes::new();
        bytes.append(Bytes::from(core::codec::encode(order.admin)));
        bytes.append(Bytes::from(core::codec::encode(order.buyer)));
        bytes.append(Bytes::from(core::codec::encode(order.asset)));
        bytes.append(Bytes::from(core::codec::encode(order.payment_token)));
        bytes.append(Bytes::from(core::codec::encode(order.token_id)));
        bytes.append(Bytes::from(core::codec::encode(order.supply)));
        bytes.append(Bytes::from(core::codec::encode(order.price)));
        bytes.append(Bytes::from(core::codec::encode(order.expiration_time)));
        bytes.append(Bytes::from(core::codec::encode(order.salt)));
        bytes.append(Bytes::from(core::codec::encode(order.question_id)));
        bytes.append(Bytes::from(core::codec::encode(order.side)));
        bytes
    })
}

fn hash_order(order: Order) -> b256 {
    std::hash::keccak256({
        let mut bytes = Bytes::new();
        bytes.append(Bytes::from(core::codec::encode(order.seller)));
        bytes.append(Bytes::from(core::codec::encode(order.buyer)));
        bytes.append(Bytes::from(core::codec::encode(order.asset)));
        bytes.append(Bytes::from(core::codec::encode(order.payment_token)));
        bytes.append(Bytes::from(core::codec::encode(order.token_id)));
        bytes.append(Bytes::from(core::codec::encode(order.supply)));
        bytes.append(Bytes::from(core::codec::encode(order.price)));
        bytes.append(Bytes::from(core::codec::encode(order.expiration_time)));
        bytes.append(Bytes::from(core::codec::encode(order.salt)));
        bytes
    })
}

#[storage(read, write)]
fn _execute_order(order: Order, hash: b256) {
    require(storage.whitelisted_address.get(order.payment_token).read(), "Not whitelisted address");
    require(!storage.fills.get(hash).read(), "Order already executed");
    require(order.expiration_time != 0 && order.expiration_time >= std::block::timestamp().as_u256(), "Order Expired");
    storage.fills.get(hash).write(true);
    log(CricSageStoreEvent::OrderExecuted((order.asset, order.admin, order.buyer, order.payment_token, order.token_id, order.supply, order.price, hash)));
}

#[storage(read, write)]
fn _execute_order_by_mint(order: Order, hash: b256) {
    require(storage.whitelisted_address.get(order.payment_token).read(), "Not whitelisted address");
    require(!storage.fills.get(hash).read(), "Order already executed");
    require(order.expiration_time != 0 && order.expiration_time >= std::block::timestamp().as_u256(), "Order Expired");
    storage.fills.get(hash).write(true);
    log(CricSageStoreEvent::mintandBuyOrderExecuted((order.asset, order.admin, order.buyer, order.payment_token, order.token_id, order.supply, order.price, order.question_id, order.side, hash)));
}

impl CricSageStore for Contract {
    #[storage(read, write)]
    fn constructor(signer: Identity, admin: Identity) {
        require(!storage.cric_sage_store_constructor_called.read(), "The CricSageStore constructor has already been called");
        storage.cric_sage_store_constructor_called.write(true);
    }

    #[storage(read)]
    fn paused() -> bool {
        ::pausable_paused()
    }

    #[storage(read)]
    fn owner() -> Identity {
        ::ownable_owner()
    }

    #[storage(read, write)]
    fn renounce_ownership() {
        ::ownable_renounce_ownership()
    }

    #[storage(read, write)]
    fn transfer_ownership(new_owner: Identity) {
        ::ownable_transfer_ownership(new_owner)
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
    fn pause() {
        only_owner();
        pausable__pause();
    }

    #[storage(read, write)]
    fn unpause() {
        only_owner();
        pausable__unpause();
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
    fn execute_order_by_relayer(order: Order, sign: Sign) {
        when_not_paused();
        require(storage.is_relayer_wallet.get(msg_sender().unwrap()).read(), "Caller is not a relayer");
        let hash = hash_order(order);
        _execute_order(order, hash);
    }

    #[storage(read, write)]
    fn execute_order_by_buyer(order: Order, sign: Sign) {
        when_not_paused();
        require(order.buyer == msg_sender().unwrap(), "Buyer and sender should be same");
        let hash = hash_order(order);
        _execute_order(order, hash);
    }

    #[storage(read, write)]
    fn execute_order_by_mint_and_buy(order: Order, sign: Sign) {
        when_not_paused();
        require(order.buyer == msg_sender().unwrap(), "Buyer and sender should be same");
        let hash = hash_order_primary(order);
        _execute_order_by_mint(order, hash);
    }

    fn hash_order_primary(order: Order) -> b256 {
        ::hash_order_primary(order)
    }

    fn hash_order(order: Order) -> b256 {
        ::hash_order(order)
    }

    fn hash_mint_and_execute_order(celebrity_address: Identity, token_uri: str, order: Order) -> b256 {
        std::hash::keccak256({
            let mut bytes = Bytes::new();
            bytes.append(Bytes::from(core::codec::encode(celebrity_address)));
            bytes.append(Bytes::from(core::codec::encode(token_uri)));
            bytes.append(Bytes::from(core::codec::encode(order.seller)));
            bytes.append(Bytes::from(core::codec::encode(order.buyer)));
            bytes.append(Bytes::from(core::codec::encode(order.asset)));
            bytes.append(Bytes::from(core::codec::encode(order.payment_token)));
            bytes.append(Bytes::from(core::codec::encode(order.token_id)));
            bytes.append(Bytes::from(core::codec::encode(order.supply)));
            bytes.append(Bytes::from(core::codec::encode(order.price)));
            bytes.append(Bytes::from(core::codec::encode(order.expiration_time)));
            bytes.append(Bytes::from(core::codec::encode(order.salt)));
            bytes
        })
    }
}

