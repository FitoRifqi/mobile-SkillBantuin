import '../models/task_models.dart';

class MockTaskService {
  List<HelperCategory> getClientCategories() {
    return const [
      HelperCategory(title: 'Desain Grafis', subtitle: 'Poster, feed, branding'),
      HelperCategory(title: 'Programming', subtitle: 'Web, mobile, bug fixing'),
      HelperCategory(title: 'Translate', subtitle: 'EN-ID dan sebaliknya'),
      HelperCategory(title: 'Data Entry', subtitle: 'Input, olah, rapikan data'),
      HelperCategory(title: 'Akademik', subtitle: 'Presentasi, rangkuman, riset'),
      HelperCategory(title: 'Editing Video', subtitle: 'Short video dan reels'),
    ];
  }

  List<RecommendedFreelancer> getRecommendedFreelancers() {
    return const [
      RecommendedFreelancer(
        name: 'Nadia Putri',
        skill: 'Desain Grafis',
        rating: 4.9,
        responseTime: '< 10 menit',
        baseRate: 35000,
      ),
      RecommendedFreelancer(
        name: 'Raka Aditya',
        skill: 'Programming',
        rating: 4.8,
        responseTime: '< 30 menit',
        baseRate: 50000,
      ),
      RecommendedFreelancer(
        name: 'Maya Pratama',
        skill: 'Akademik',
        rating: 4.9,
        responseTime: '< 20 menit',
        baseRate: 30000,
      ),
    ];
  }

  List<ClientTask> getClientTasks() {
    return const [
      ClientTask(
        id: 'task-001',
        title: 'Bantu Desain Poster Seminar',
        category: 'Desain Grafis',
        description:
            'Butuh poster seminar kampus ukuran A4 untuk publikasi Instagram dan WhatsApp. Sudah ada isi teks, tinggal dirapikan dan dibuat menarik.',
        initialBudget: 30000,
        agreedBudget: 32000,
        deadlineLabel: '3 Mei 2026',
        createdAtLabel: '1 Mei 2026',
        status: TaskStatus.negotiation,
        paymentStatus: PaymentStatus.unpaid,
        assistanceType: AssistanceType.online,
        nearestAction: 'Tinjau 3 penawaran volunteer',
        progress: 25,
        assignedFreelancer: 'Nadia Putri',
        attachmentName: 'brief-poster.pdf',
        offers: [
          VolunteerOffer(
            id: 'offer-001',
            freelancerName: 'Nadia Putri',
            freelancerSkill: 'Graphic Designer',
            rating: 4.9,
            completedTasks: 48,
            offeredBudget: 35000,
            proposedDeadline: '1 hari',
            message: 'Saya bisa bantu desain poster modern dengan 2 opsi revisi.',
            status: OfferStatus.countered,
          ),
          VolunteerOffer(
            id: 'offer-002',
            freelancerName: 'Dewi Laras',
            freelancerSkill: 'Visual Designer',
            rating: 4.8,
            completedTasks: 31,
            offeredBudget: 33000,
            proposedDeadline: '2 hari',
            message: 'Siap bantu dengan style kampus yang formal dan tetap menarik.',
            status: OfferStatus.pending,
          ),
          VolunteerOffer(
            id: 'offer-003',
            freelancerName: 'Rian Saputra',
            freelancerSkill: 'Content Designer',
            rating: 4.7,
            completedTasks: 22,
            offeredBudget: 30000,
            proposedDeadline: '2 hari',
            message: 'Budget sesuai, saya bisa mulai malam ini setelah brief final.',
            status: OfferStatus.pending,
          ),
        ],
      ),
      ClientTask(
        id: 'task-002',
        title: 'Rapikan Data Absensi Excel',
        category: 'Data Entry',
        description:
            'Butuh bantuan merapikan file absensi mahasiswa menjadi format yang siap direkap dan dipresentasikan.',
        initialBudget: 45000,
        agreedBudget: 45000,
        deadlineLabel: '4 Mei 2026',
        createdAtLabel: '30 Apr 2026',
        status: TaskStatus.waitingPayment,
        paymentStatus: PaymentStatus.pending,
        assistanceType: AssistanceType.online,
        nearestAction: 'Upload bukti pembayaran untuk memulai pengerjaan',
        progress: 40,
        assignedFreelancer: 'Budi Santoso',
        attachmentName: 'absensi-raw.xlsx',
        offers: [
          VolunteerOffer(
            id: 'offer-004',
            freelancerName: 'Budi Santoso',
            freelancerSkill: 'Data Entry Specialist',
            rating: 5.0,
            completedTasks: 64,
            offeredBudget: 45000,
            proposedDeadline: '1 hari',
            message: 'Saya terbiasa merapikan data akademik dan bisa selesai cepat.',
            status: OfferStatus.accepted,
          ),
        ],
      ),
      ClientTask(
        id: 'task-003',
        title: 'Review PPT Sidang Proposal',
        category: 'Akademik',
        description:
            'Butuh volunteer untuk memberi masukan isi dan desain presentasi sidang proposal agar lebih rapi dan meyakinkan.',
        initialBudget: 25000,
        agreedBudget: 25000,
        deadlineLabel: '2 Mei 2026',
        createdAtLabel: '29 Apr 2026',
        status: TaskStatus.onProgress,
        paymentStatus: PaymentStatus.verified,
        assistanceType: AssistanceType.online,
        nearestAction: 'Cek progres terbaru dari freelancer',
        progress: 72,
        assignedFreelancer: 'Maya Pratama',
        attachmentName: 'draft-sidang.pptx',
        offers: [
          VolunteerOffer(
            id: 'offer-005',
            freelancerName: 'Maya Pratama',
            freelancerSkill: 'Academic Assistant',
            rating: 4.9,
            completedTasks: 39,
            offeredBudget: 25000,
            proposedDeadline: '1 hari',
            message: 'Saya bisa bantu rapikan flow slide dan highlight poin penting.',
            status: OfferStatus.accepted,
          ),
        ],
      ),
      ClientTask(
        id: 'task-004',
        title: 'Edit Video Reels Event Kampus',
        category: 'Editing Video',
        description:
            'Perlu bantuan edit reels 30 detik untuk recap event kampus dengan musik dan subtitle ringan.',
        initialBudget: 50000,
        agreedBudget: 50000,
        deadlineLabel: '30 Apr 2026',
        createdAtLabel: '26 Apr 2026',
        status: TaskStatus.submitted,
        paymentStatus: PaymentStatus.verified,
        assistanceType: AssistanceType.online,
        nearestAction: 'Tinjau hasil yang sudah dikirim sebelum konfirmasi selesai',
        progress: 95,
        assignedFreelancer: 'Raka Aditya',
        attachmentName: 'footage-event.zip',
        offers: [
          VolunteerOffer(
            id: 'offer-006',
            freelancerName: 'Raka Aditya',
            freelancerSkill: 'Video Editor',
            rating: 4.8,
            completedTasks: 27,
            offeredBudget: 50000,
            proposedDeadline: '2 hari',
            message: 'Saya bisa kirim versi landscape dan portrait sekaligus.',
            status: OfferStatus.accepted,
          ),
        ],
      ),
      ClientTask(
        id: 'task-005',
        title: 'Terjemahkan Abstrak Bahasa Inggris',
        category: 'Translate',
        description:
            'Butuh bantuan translate abstrak 2 halaman dari Bahasa Indonesia ke Bahasa Inggris akademik.',
        initialBudget: 20000,
        agreedBudget: 20000,
        deadlineLabel: '28 Apr 2026',
        createdAtLabel: '25 Apr 2026',
        status: TaskStatus.completed,
        paymentStatus: PaymentStatus.verified,
        assistanceType: AssistanceType.online,
        nearestAction: 'Beri rating dan review untuk volunteer',
        progress: 100,
        assignedFreelancer: 'Siti Maharani',
        offers: [
          VolunteerOffer(
            id: 'offer-007',
            freelancerName: 'Siti Maharani',
            freelancerSkill: 'Translator',
            rating: 5.0,
            completedTasks: 56,
            offeredBudget: 20000,
            proposedDeadline: '1 hari',
            message: 'Siap bantu terjemahan formal dengan revisi minor jika perlu.',
            status: OfferStatus.accepted,
          ),
        ],
      ),
    ];
  }

  ClientTask getTaskById(String id) {
    return getClientTasks().firstWhere((task) => task.id == id);
  }

  List<AvailableTask> getAvailableTasks() {
    return const [
      AvailableTask(
        id: 'available-001',
        title: 'Bantu Desain Poster Seminar',
        category: 'Desain Grafis',
        description:
            'Client butuh poster seminar kampus dengan gaya modern, format A4 dan versi Instagram Story.',
        initialBudget: 30000,
        deadlineLabel: '3 Mei 2026',
        assistanceType: AssistanceType.online,
        clientName: 'Dina Amelia',
        postedLabel: '3 jam lalu',
        applicantsCount: 4,
        budgetRangeLabel: 'Rp30.000 - Rp35.000',
        location: 'Online',
      ),
      AvailableTask(
        id: 'available-002',
        title: 'Rapikan Data Absensi Excel',
        category: 'Data Entry',
        description:
            'Perlu volunteer untuk membersihkan data absensi dan membuat rekap sederhana yang siap dipresentasikan.',
        initialBudget: 45000,
        deadlineLabel: '4 Mei 2026',
        assistanceType: AssistanceType.online,
        clientName: 'Budi Santosa',
        postedLabel: 'Hari ini',
        applicantsCount: 7,
        budgetRangeLabel: 'Rp45.000',
        location: 'Online',
      ),
      AvailableTask(
        id: 'available-003',
        title: 'Review PPT Sidang Proposal',
        category: 'Akademik',
        description:
            'Cari bantuan untuk review isi slide dan memperbaiki flow presentasi sidang proposal.',
        initialBudget: 25000,
        deadlineLabel: '2 Mei 2026',
        assistanceType: AssistanceType.online,
        clientName: 'Maya Fitri',
        postedLabel: '1 hari lalu',
        applicantsCount: 2,
        budgetRangeLabel: 'Rp25.000 - Rp30.000',
        location: 'Online',
      ),
      AvailableTask(
        id: 'available-004',
        title: 'Edit Video Reels Event Kampus',
        category: 'Editing Video',
        description:
            'Client butuh editor untuk reels 30 detik lengkap subtitle, musik, dan versi portrait.',
        initialBudget: 50000,
        deadlineLabel: '5 Mei 2026',
        assistanceType: AssistanceType.online,
        clientName: 'Rian Kurniawan',
        postedLabel: 'Kemarin',
        applicantsCount: 5,
        budgetRangeLabel: 'Rp50.000',
        location: 'Online',
      ),
    ];
  }

  AvailableTask getAvailableTaskById(String id) {
    return getAvailableTasks().firstWhere((task) => task.id == id);
  }

  List<FreelancerApplication> getFreelancerApplications() {
    return const [
      FreelancerApplication(
        id: 'application-001',
        taskTitle: 'Bantu Desain Poster Seminar',
        category: 'Desain Grafis',
        offeredBudget: 35000,
        proposedDeadline: '1 hari',
        note: 'Client menawar balik ke Rp32.000 dengan revisi maksimal 2 kali.',
        status: OfferStatus.countered,
        updatedAtLabel: '10 menit lalu',
      ),
      FreelancerApplication(
        id: 'application-002',
        taskTitle: 'Rapikan Data Absensi Excel',
        category: 'Data Entry',
        offeredBudget: 45000,
        proposedDeadline: '1 hari',
        note: 'Offer diterima, menunggu pembayaran diverifikasi.',
        status: OfferStatus.accepted,
        updatedAtLabel: 'Hari ini',
      ),
      FreelancerApplication(
        id: 'application-003',
        taskTitle: 'Terjemahkan Abstrak Bahasa Inggris',
        category: 'Translate',
        offeredBudget: 22000,
        proposedDeadline: '1 hari',
        note: 'Masih menunggu review client.',
        status: OfferStatus.pending,
        updatedAtLabel: 'Kemarin',
      ),
      FreelancerApplication(
        id: 'application-004',
        taskTitle: 'Pembuatan UI Dashboard Figma',
        category: 'Desain Grafis',
        offeredBudget: 60000,
        proposedDeadline: '2 hari',
        note: 'Client memilih volunteer lain untuk task ini.',
        status: OfferStatus.rejected,
        updatedAtLabel: '2 hari lalu',
      ),
    ];
  }

  List<FreelancerWorkItem> getFreelancerWorks() {
    return const [
      FreelancerWorkItem(
        id: 'work-001',
        taskTitle: 'Rapikan Data Absensi Excel',
        clientName: 'Budi Santosa',
        deadlineLabel: '4 Mei 2026',
        agreedBudget: 45000,
        progress: 35,
        status: WorkStatus.inProgress,
        nextStep: 'Lengkapi sheet rekap lalu kirim hasil awal malam ini.',
      ),
      FreelancerWorkItem(
        id: 'work-002',
        taskTitle: 'Review PPT Sidang Proposal',
        clientName: 'Maya Fitri',
        deadlineLabel: '2 Mei 2026',
        agreedBudget: 25000,
        progress: 0,
        status: WorkStatus.notStarted,
        nextStep: 'Mulai review slide setelah brief final dikirim client.',
      ),
      FreelancerWorkItem(
        id: 'work-003',
        taskTitle: 'Edit Video Reels Event Kampus',
        clientName: 'Rian Kurniawan',
        deadlineLabel: '30 Apr 2026',
        agreedBudget: 50000,
        progress: 100,
        status: WorkStatus.waitingConfirmation,
        nextStep: 'Menunggu client konfirmasi hasil final.',
      ),
      FreelancerWorkItem(
        id: 'work-004',
        taskTitle: 'Terjemahkan Abstrak Bahasa Inggris',
        clientName: 'Salsa Aulia',
        deadlineLabel: '28 Apr 2026',
        agreedBudget: 20000,
        progress: 100,
        status: WorkStatus.completed,
        nextStep: 'Tugas selesai dan siap masuk riwayat pendapatan.',
      ),
    ];
  }

  List<EarningTransaction> getEarningTransactions() {
    return const [
      EarningTransaction(
        id: 'earning-001',
        title: 'Rapikan Data Absensi Excel',
        amount: 45000,
        status: PaymentStatus.pending,
        dateLabel: '1 Mei 2026',
      ),
      EarningTransaction(
        id: 'earning-002',
        title: 'Edit Video Reels Event Kampus',
        amount: 50000,
        status: PaymentStatus.verified,
        dateLabel: '30 Apr 2026',
      ),
      EarningTransaction(
        id: 'earning-003',
        title: 'Terjemahkan Abstrak Bahasa Inggris',
        amount: 20000,
        status: PaymentStatus.verified,
        dateLabel: '28 Apr 2026',
      ),
      EarningTransaction(
        id: 'earning-004',
        title: 'UI Dashboard Figma',
        amount: 60000,
        status: PaymentStatus.failed,
        dateLabel: '26 Apr 2026',
      ),
    ];
  }
}
