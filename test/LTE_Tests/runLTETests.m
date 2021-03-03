function results = runLTETests(BoardName, LOStepSize)
    import matlab.unittest.parameters.Parameter
    import matlab.unittest.TestSuite
    import matlab.unittest.TestRunner
    import matlab.unittest.plugins.XMLPlugin

    if nargin == 0
        error('BoardName cannot be empty to run LTE test harness');
    end
    
    if nargin == 1
        LOStepSize = 500e6;
    end
    
    switch BoardName
        case "pluto"
            Tx = adi.Pluto.Tx;
            Tx.uri = 'ip:pluto';
            Rx = adi.Pluto.Rx;
            Rx.uri = 'ip:pluto';
            AD936xClassTx = {Tx};
            AD936xClassRx = {Rx};
            LOFreqs = num2cell(325e6:LOStepSize:3800e6);
        case {"zynq-adrv9361-z7035-bob-cmos", ...
                "socfpga_cyclone5_sockit_arradio", ...
                "zynq-zed-adv7511-ad9361-fmcomms2-3", ...
                "zynq-zc702-adv7511-ad9361-fmcomms2-3", ...
                "zynq-zc706-adv7511-ad9361-fmcomms2-3", ...
                "zynqmp-zcu102-rev10-ad9361-fmcomms2-3", ...
                "zynq-adrv9361-z7035-fmc", ...
                "zynq-adrv9361-z7035-box", ...
                "zynq-adrv9361-z7035-bob"}
            Tx = adi.AD9361.Tx;
            Tx.uri = 'ip:analog';
            Rx = adi.AD9361.Rx;
            Rx.uri = 'ip:analog';
            AD936xClassTx = {Tx};
            AD936xClassRx = {Rx};
            LOFreqs = num2cell(70e6:LOStepSize:6000e6);
        case {"zynq-zc702-adv7511-ad9364-fmcomms4", ...
                "zynq-zc706-adv7511-ad9364-fmcomms4", ...
                "zynqmp-zcu102-rev10-ad9364-fmcomms4", ...
                "zynq-adrv9364-z7020-box", ...
                "zynq-adrv9364-z7020-bob", ...
                "zynq-adrv9364-z7020-bob-cmos", ...
                "zynq-zed-adv7511-ad9364-fmcomms4"}
            Tx = adi.AD9364.Tx;
            Tx.uri = 'ip:analog';
            Rx = adi.AD9364.Rx;
            Rx.uri = 'ip:analog';
            AD936xClassTx = {Tx};
            AD936xClassRx = {Rx};
            LOFreqs = num2cell(70e6:LOStepSize:6000e6);
        otherwise
            error('%s unsupported for LTE test harness', BoardName);
    end
    params = Parameter.fromData('AD936xClassTx',AD936xClassTx, ...
        'AD936xClassRx',AD936xClassRx, ...
        'LOFreqs', LOFreqs);
    suite = TestSuite.fromClass(?AD936x_LTETests, ...
        'ExternalParameters', params);
    xmlFile = 'LTETestResults.xml';
    runner = TestRunner.withTextOutput('LoggingLevel',4);
    runner.addPlugin(details_recording_plugin);
    plugin = XMLPlugin.producingJUnitFormat(xmlFile);
    runner.addPlugin(plugin);
    results = runner.run(suite);
    try
        log_lte_evm_test(results);
    catch
        error('cannot find telemetry');
    end
    
    if ~usejava('desktop')
        exit(any([results.Failed]));
    end
end