import SwiftUI

struct ReportModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let reportOptions = ["It's rude, vulgar or uses bad language",
                         "It's sexually explicit",
                         "It's harassment or hate speech",
                         "It's threatening, violent or suicidal",
                         "Something else"]
    
    @State private var itemUID:String? = ""
    @State private var postUserUID:String? = ""
    @State private var selectedOptions: Set<String> = []
    
    
    @ObservedObject var vm : ReportModalViewModel
    init(itemUID:String?, postUserUID:String?) {
        self.vm = ReportModalViewModel(itemUID: (itemUID ?? ""), postUserUID: (postUserUID ?? ""))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center){
                    Text("Report this content")
                        .font(.headline)
                        .padding(.top, 20)
                    Image(systemName: "light.beacon.max")
                        .baselineOffset(0) // add this modifier
                }
                .frame(maxWidth: .infinity)
                List {
                    ForEach(reportOptions, id: \.self) { option in
                        Button(action: {
                            if let index = selectedOptions.firstIndex(of: option) {
                                selectedOptions.remove(at: index)
                            } else {
                                selectedOptions.insert(option)
                            }
                        }) {
                            HStack {
                                Image(systemName: selectedOptions.contains(option) ? "checkmark.square" : "square").foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                                Text(option)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                
                Button(action: {
                    // Perform action when submit button is tapped
                    vm.writeReport(selectedOptions: selectedOptions)
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0x5F879D, alpha: 1))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct ReportModalView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
