import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 1)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 3
    #dut.uio_in.value = 30

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = 0
    # Read and log the output value
    output_value = dut.uo_out.value
    dut._log.info(f"Output value: {output_value}")
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = 11
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 0
    # Read and log the output value
    output_value = dut.uo_out.value
    dut._log.info(f"Output value: {output_value}")
