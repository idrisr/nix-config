def test_grub_install_fails_without_bios_boot(machine):
    machine.start()
    machine.wait_for_unit("multi-user.target")

    result = machine.succeed_or_fail("grub-install --target=i386-pc --boot-directory=/boot /dev/vda")
    assert "no BIOS Boot Partition" not in result
    assert "Embedding is not possible" in result
    assert "will not proceed with blocklists" in result
