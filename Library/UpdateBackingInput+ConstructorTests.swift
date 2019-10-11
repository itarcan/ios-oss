@testable import KsApi
@testable import Library
import XCTest

final class UpdateBackingInput_ConstructorTests: TestCase {
  func testUpdateBackingInput_UpdateBackingData() {
    let applePayParams = ApplePayParams(
      paymentInstrumentName: "paymentInstrumentName",
      paymentNetwork: "paymentNetwork",
      transactionIdentifier: "transactionIdentifier",
      token: "token"
    )

    let data: UpdateBackingData = (
      backing: Backing.template,
      reward: Reward.template,
      pledgeAmount: 100,
      shippingRule: ShippingRule.template,
      paymentSourceId: GraphUserCreditCard.amex.id,
      applePayParams: applePayParams
    )

    let input = UpdateBackingInput.input(from: data)

    XCTAssertEqual(input.amount, "105.00")
    XCTAssertEqual(input.applePay, applePayParams)
    XCTAssertEqual(input.id, "QmFja2luZy0x")
    XCTAssertEqual(input.locationId, "42")
    XCTAssertEqual(input.paymentSourceId, "6")
    XCTAssertEqual(input.rewardId, "UmV3YXJkLTE=")
  }
}
