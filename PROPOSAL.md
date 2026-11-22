# Capstone proposal — Card shop

Mason Dedeaux · ISM3232 · Week 13

## The business

The shop sells trading cards for in-store pickup. Customers call before making the trip because they want to know whether a particular card is in stock or whether their pickup order is ready.

## Who uses it

Customers use the chat to check card availability and pickup orders. Shop staff use the Staff tab to review customer requests.

## Tables

| Table | Columns and keys | Example |
| --- | --- | --- |
| `inventory` | `set_name TEXT` and `card_number TEXT` together form the primary key. `card_name TEXT` and `stock INTEGER` record the name and available copies. | Base Set, #58, Pikachu, 3 copies |
| `pickup_orders` | `order_id TEXT` is the primary key. `status TEXT` and `pickup_date TEXT` record the order's progress and scheduled day. | P1001, ready, 2026-12-02 |
| `change_requests` | `number INTEGER` is the automatic primary key. `order_id TEXT` links to a pickup order, `new_value TEXT` holds the requested date, and `status TEXT` defaults to `waiting`. | Starts empty. A request filed later might be 1, P1002, 2026-12-05, waiting. |

Card numbers can repeat across sets. Using the set and number together lets the shop track different printings separately.

## Lookup tools

| Customer question | Read-only lookup | What it checks |
| --- | --- | --- |
| Do you have the Base Set Pikachu in stock? | `check_stock(card_name, set_name, card_number=None)` reads the available copies. | Require a name and set. If more than one printing matches, ask for the card number. An unknown card and a card with zero stock get different answers. |
| Is my pickup order ready? | `check_pickup(order_id)` reads the status and scheduled date. | Trim spaces, capitalize the ID, and check for P followed by four digits. If the customer leaves it out, ask for it. If the order is missing, say so. |

## Change tool

`request_pickup_change(order_id, new_date)` lets a customer ask to move a pickup. It requires an existing order that has not been picked up and a valid calendar date in YYYY-MM-DD format. The tool files one waiting request and returns its number. The order keeps its scheduled date while staff review the request.

| Staff decision | Request status | Pickup date on the order |
| --- | --- | --- |
| Approve | Approved | Changes to the requested date |
| Decline | Rejected | Stays on the original date |

Approving applies the date and records the decision together. Only waiting requests can be decided.

## Handoff rule

Before the model sees a message, route payment and refund questions to staff. Match words or phrases such as “refund,” “charged twice,” “credit card,” or “debit card.” A question about a Pikachu card can still use the stock lookup. The reason for the README is that only staff can check a charge or issue a refund.

## Data it never stores

Keep payment card numbers out of the database, chat history, and model input. If a message contains a payment card number, send it straight to staff review without retaining or forwarding the number.

## Instructions draft

You help customers at a trading card shop that offers in-store pickup. Use the inventory lookup for stock questions and the order lookup for pickup status. Ask for missing details. A pickup date changes only after staff approve the request. If you do not know the answer, say so and offer to connect the customer with staff. Only state facts that appear in these instructions or in tool results.

## Five sample conversations

1. “Do you have the Base Set Pikachu in stock?” Check inventory and report 3 copies.
2. “Is my order ready?” Ask for the order number. When the customer replies “P1001,” look it up and report that it is ready for pickup on December 2, 2026.
3. “Can I move P1002 to 2026-12-05?” File exactly one waiting request. Explain that the order is still scheduled for December 3 until staff approve.
4. “Move my pickup to 2026-12-05.” Ask for the order number and file zero requests until the customer supplies it.
5. “I was charged twice. Can I get a refund?” Route the customer to staff before calling the model or a lookup tool.

## Out of scope

- Taking payments or issuing refunds through chat.
- Reserving cards or placing new orders through a stock lookup.

## Checklist

- [x] Which business did I choose? Who will use the chat, and who will use the Staff tab?
- [x] Which two questions will people ask? Which table, columns, primary key, and example row does each question need? What goes in the separate change_requests table?
- [x] What are my two read-only lookup tools? Which arguments does each check?
- [x] What change can someone request? What does the tool record? What happens when staff approve or reject it?
- [x] What should trigger a handoff before the model runs? What reason will I give in the README?
- [x] What sensitive information will the app keep out of both the database and the model?
- [x] What facts can the agent give about the business? Do my instructions include "only state facts that appear in these instructions"?
- [x] Have I written five sample conversations, each with an outcome I can test? Does at least one check a safety rule?
