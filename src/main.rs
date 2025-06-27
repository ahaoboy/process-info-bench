// use std::{ffi::OsString, os::windows::ffi::OsStringExt};

use windows::Win32::{
    Foundation::{CloseHandle, HANDLE, INVALID_HANDLE_VALUE},
    System::Diagnostics::ToolHelp::{
        CreateToolhelp32Snapshot, PROCESSENTRY32W, Process32FirstW, Process32NextW,
        TH32CS_SNAPPROCESS,
    },
};

pub fn process_info(pid: u32, deep: u32) -> u32 {
    unsafe {
        let snapshot: HANDLE = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
            .ok()
            .unwrap_or(INVALID_HANDLE_VALUE);
        if snapshot == INVALID_HANDLE_VALUE {
            return deep;
        }

        let mut entry = PROCESSENTRY32W {
            dwSize: std::mem::size_of::<PROCESSENTRY32W>() as u32,
            ..Default::default()
        };

        if Process32FirstW(snapshot, &mut entry).is_ok() {
            loop {
                if entry.th32ProcessID == pid {
                    let ppid = entry.th32ParentProcessID;
                    // let name = {
                    //     let len = (0..entry.szExeFile.len())
                    //         .position(|i| entry.szExeFile[i] == 0)
                    //         .unwrap_or(entry.szExeFile.len());
                    //     OsString::from_wide(&entry.szExeFile[..len])
                    //         .to_string_lossy()
                    //         .into_owned()
                    // };
                    // println!("pid: {ppid} name: {name}");
                    CloseHandle(snapshot).unwrap();
                    return process_info(ppid, deep + 1);
                }
                if Process32NextW(snapshot, &mut entry).is_err() {
                    break;
                }
            }
        }

        CloseHandle(snapshot).unwrap();
        return deep;
    }
}

fn main() {
    let pid = std::process::id();
    let deep = process_info(pid, 0);
    println!("deep: {deep}");
}
