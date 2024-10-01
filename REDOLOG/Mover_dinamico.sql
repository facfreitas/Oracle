Select 'alter database rename file '''||member||''' '|| ' TO '''||
            decode(substr(member,1,20),
                    'J:\REDO\SGF\REDO01_A',
                    replace(member,'J:\REDO\SGF\REDO01_A','H:\Oracle\SGF\DATA\redoA\REDO01_A'),
                    'J:\REDO\SGF\REDO01_B',
                    replace(member,'J:\REDO\SGF\REDO01_B','I:\Oracle\SGF\DATA\redoB\REDO01_B'),
                    'J:\REDO\SGF\REDO02_A',
                    replace(member,'J:\REDO\SGF\REDO02_A','I:\Oracle\SGF\DATA\redoA\REDO02_A'),
                    'J:\REDO\SGF\REDO02_B',
                    replace(member,'J:\REDO\SGF\REDO02_B','H:\Oracle\SGF\DATA\redoB\REDO02_B'),
                    'J:\REDO\SGF\REDO03_A',
                    replace(member,'J:\REDO\SGF\REDO03_A','J:\Oracle\SGF\DATA\redoA\REDO03_A'),
                    'J:\REDO\SGF\REDO03_B',
                    replace(member,'J:\REDO\SGF\REDO03_B','I:\Oracle\SGF\DATA\redoB\REDO03_B'))||''';' cmd
            from v$logfile


