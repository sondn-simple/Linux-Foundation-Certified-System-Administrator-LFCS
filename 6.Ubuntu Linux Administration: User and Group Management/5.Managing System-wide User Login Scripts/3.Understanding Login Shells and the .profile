╔══════════════════════════════════════════════════════════════════════════════╗
║          UNDERSTANDING LOGIN SHELLS AND THE .PROFILE                         ║
║       (Hiểu Về Login Shell Và File .profile)                                 ║
╚══════════════════════════════════════════════════════════════════════════════╝


TỔNG QUAN BÀI HỌC
────────────────────────────────────────────────────────────────

  Chủ đề     : Login shell, file .profile, .bash_logout, và cách
               chỉnh sửa nhanh bằng lệnh sed
  Mục tiêu   : Hiểu khi nào .profile và .bash_logout thực thi, và
               cách chỉnh sửa umask, thêm lệnh clear vào logout script

LOGIN SHELL LÀ GÌ?
────────────────────────────────────────────────────────────────

  • Login shell: được thực thi khi user ĐĂNG NHẬP, bất kể có phải
    shell tương tác (interactive) hay không

  • File .profile
      - Thực thi vào ĐẦU phiên làm việc (session) của user
      - CHỈ chạy MỘT LẦN trong suốt phiên đăng nhập đó
      - Giúp GIẢM tải xử lý vì không phải chạy lại mỗi khi mở Bash
        shell mới

  • File .bash_logout
      - Thực thi khi user THOÁT khỏi login shell
      - KHÔNG thực thi khi:
          • Chỉ đóng một Bash shell chạy TƯƠNG TÁC thông thường
          • Dùng su (không phải su -) - tức là NON-LOGIN SHELL

CHỈNH SỬA UMASK TRONG .PROFILE
────────────────────────────────────────────────────────────────

  • Giá trị umask mặc định cho user thường trên Ubuntu: 0002
      - Chỉ loại bỏ quyền WRITE của others (người khác)

  • Trong file .profile, thường có dòng umask BỊ COMMENT SẴN với
    giá trị 22
      - Giá trị 22 sẽ loại bỏ quyền WRITE của cả GROUP và OTHERS
        (nghiêm ngặt hơn giá trị mặc định)

  • Bỏ comment dòng umask bằng lệnh sed (stream editor):
      sed -i 's/^#umask/umask/' ~/.profile

      - -i          : in-place edit (sửa trực tiếp trên file)
      - Tìm dòng BẮT ĐẦU bằng "#umask" (dấu # + umask)
      - Thay thế bằng "umask" (bỏ dấu # đi)

  • Muốn COMMENT LẠI dòng umask (ngược lại):
      sed -i 's/^umask/#umask/' ~/.profile

      - Tìm dòng BẮT ĐẦU bằng "umask"
      - Thêm dấu # vào trước để comment lại

CHỈNH SỬA .BASH_LOGOUT
────────────────────────────────────────────────────────────────

  • Mặc định file .bash_logout có lệnh: clear_console
      - Dùng để xóa màn hình khi logout

  • VẤN ĐỀ: clear_console KHÔNG hoạt động với PSEUDO TERMINAL
      - Pseudo terminal: các terminal phần mềm được cấp khi kết nối
        qua SSH, hoặc mở terminal đồ họa (vd: GNOME Terminal) trên
        hệ thống desktop
      - Nghĩa là: dù có .bash_logout, màn hình SẼ KHÔNG được xóa khi
        logout qua SSH

  • GIẢI PHÁP: thêm lệnh clear (khác với clear_console) vào cuối file

  • Thêm dòng "clear" vào CUỐI file bằng sed:
      sed -i '$a clear' ~/.bash_logout

      - $ (dollar) : đại diện cho DÒNG CUỐI CÙNG của file
      - a           : append (chèn thêm) sau dòng đó
      - "clear"     : nội dung được thêm vào

  • Muốn XÓA dòng cuối cùng vừa thêm (undo lại thay đổi trên):
      sed -i '$d' ~/.bash_logout

      - d : delete (xóa) dòng cuối cùng

CÀI ĐẶT TÀI LIỆU THAM KHẢO THÊM
────────────────────────────────────────────────────────────────

  • Cài đặt package chứa tài liệu mẫu:
      sudo apt update
      sudo apt install bash-doc

  • Xem các file mẫu tham khảo tại:
      /usr/share/doc/bash/examples/startup-files

      - Chứa các script mẫu (sample scripts) hữu ích để tham khảo
        thêm cách viết login script

KẾT LUẬN
────────────────────────────────────────────────────────────────

  .profile và .bash_logout là 2 login script quan trọng gắn với
  LOGIN SHELL:
    - .profile      : chạy 1 lần khi bắt đầu session, có thể dùng
                       để tùy chỉnh umask hoặc các thiết lập khác
    - .bash_logout   : chạy khi logout khỏi login shell, cần lưu ý
                        vấn đề với pseudo terminal (SSH) khi dùng
                        clear_console
  Lệnh sed là công cụ mạnh để chỉnh sửa nhanh các file này mà không
  cần mở trình soạn thảo, đặc biệt hữu ích khi làm việc với script
  hoặc tự động hóa.


────────────────────────────────────────────────────────────────
Tiếp theo: Thực hành trực tiếp trên dòng lệnh với .profile và
.bash_logout.
────────────────────────────────────────────────────────────────