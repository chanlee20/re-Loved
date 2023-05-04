import SwiftUI
struct ChatCellView: View {
    var recentMessage: RecentMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ProfileImageView(profileImageURL: recentMessage.profileImageURL)
                .frame(width: 48, height: 48)
                .padding(.trailing, 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recentMessage.opponent_name)
                    .foregroundColor(Color(hex: 0x29556D, alpha: 1))
                    .font(.system(size: 16, weight: .semibold))
                Text(recentMessage.text)
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Spacer()
            
            Text(recentMessage.timeago)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.secondaryLabel))
                .padding(10)
        }
        
        .padding(.vertical, 15)
    }
}
