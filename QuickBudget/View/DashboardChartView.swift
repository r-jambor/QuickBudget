import SwiftUI
import SwiftData
import Charts

struct DashboardChartView: View {
    
    @Query var cashFlow: [CashFlowModel]
    @Environment(\.modelContext) private var context
    @EnvironmentObject var settings: SettingsViewModel
    @StateObject private var viewModel = DashboardViewModel()
    
    var selectedMonth: Date
    
    
    
    func total(for type: String) -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        return cashFlow
            .filter { item in
                item.type == type &&
                calendar.isDate(item.date, equalTo: now, toGranularity: .month) &&
                calendar.isDate(item.date, equalTo: now, toGranularity: .year)
            }
            .map(\.amount)
            .reduce(0, +)
    }
    
    
    
    // sample data for the chart uncomment if you want to display graph
  /*  var sampleData: [CashFlowModel] = [
        CashFlowModel(amount: 100.00, date: .now, type: "Expenses", icon: "car.circle", note: ""),
        CashFlowModel(amount: 200.00, date: .now, type: "Savings", icon: "car.circle", note: ""),
        CashFlowModel(amount: 300.00, date: .now, type: "Income", icon: "car.circle", note: "")
    ]*/
    
    var body: some View {
        
        let monthItems = viewModel.items(for: selectedMonth, from: cashFlow)

       
        let currentMonthItemsChart = cashFlow.filter { item in
            Calendar.current.isDate(item.date, equalTo: Date(), toGranularity: .month)
        }
        
        ZStack{
          
            
            Chart(monthItems.sorted{$0.type < $1.type}/*sampleData*/) { dataItem in
                SectorMark(angle: .value("Amount", dataItem.amount),
                           innerRadius: .ratio(0.7),
                           angularInset: 1.5)
                .cornerRadius(5)
                .foregroundStyle(by: .value("Type", dataItem.type))
            }
            .chartLegend(position: .top, alignment: .center, spacing: 15)
            .chartForegroundStyleScale([
                "Expenses": .red,
                "Savings": .orange,
                "Income": .green
            ])
            .frame(width: 400, height: 350)
            TabView{
                TotalExpanses(selectedMonth: selectedMonth)
                TotalSavings(selectedMonth: selectedMonth)
                TotalIncome(selectedMonth: selectedMonth)
            }
            .background(.clear)
            .frame(width: 215, height: 270)
            
           // .background(Color.blue)
            .cornerRadius(200)
            .tabViewStyle(.page)
        }
    }
}

#Preview {
    DashboardChartView(selectedMonth: Date())
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(SettingsViewModel())
}

//------------------------------------------------------------------
struct TotalExpanses: View {
    @Query var cashFlow: [CashFlowModel]
    @Environment(\.modelContext) private var context
    @EnvironmentObject var settings: SettingsViewModel
    @StateObject private var viewModel = DashboardViewModel()

    var selectedMonth: Date
  
    var body: some View {
        
        let totalExpenses  = viewModel.total(for: "Expenses", in: selectedMonth, from: cashFlow)
        
        
        VStack {
            Text("- \(totalExpenses, format: .currency(code: settings.currencyCode))")
                .frame(width: 200, height: 70)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .font(.largeTitle)
            
            Text("Your income this month")
        }
    }
}

//------------------------------------------------------------
struct TotalSavings: View {
    
    @Query var cashFlow: [CashFlowModel]
    @Environment(\.modelContext) private var context
    @EnvironmentObject var settings: SettingsViewModel
    @StateObject private var viewModel = DashboardViewModel()
    
    var selectedMonth: Date
    
    var body: some View {
        
        let totalSavings  = viewModel.total(for: "Savings", in: selectedMonth, from: cashFlow)
        
        VStack {
            
            Text("\(totalSavings, format: .currency(code: settings.currencyCode))")
                .frame(width: 200, height: 70)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .font(.largeTitle)
            
            Text("Your savings this month")
        }
    }
}
//--------------------------------------------------------
struct TotalIncome: View {
    @Query var cashFlow: [CashFlowModel]
    @Environment(\.modelContext) private var context
    @EnvironmentObject var settings: SettingsViewModel
    @StateObject private var viewModel = DashboardViewModel()

    var selectedMonth: Date

    var body: some View {
        
        let totalIncome = viewModel.total(for: "Income", in: selectedMonth, from: cashFlow)
        
        VStack {
            Text("\(totalIncome, format: .currency(code: settings.currencyCode))")
                .frame(width: 200, height: 70)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .font(.largeTitle)
            
            Text("Your income this month")
        }
    }
}

