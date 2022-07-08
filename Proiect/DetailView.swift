//
//  DetailView.swift
//  Proiect
//
//  Created by m1 on 07/07/2022.
//

import SwiftUI
import UserNotifications

struct DetailView: View
{
    let book: Book

    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    @State private var animationAmount = 1.0
    
    var body: some View
    {
        ScrollView
        {
            ZStack(alignment: .bottomTrailing)
            {
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }

            Text(book.author ?? "Author")
                .font(.title)
                .foregroundColor(.secondary)

            Text(book.desc ?? "Description")
                .padding()

            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
            
        }
        .navigationTitle(book.title ?? "Book")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book?", isPresented: $showingDeleteAlert)
            {
                Button("Delete", role: .destructive, action: deleteBook)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure?")
            }
        .toolbar
            {
                Button {
                    showingDeleteAlert = true
                } label: {
                    Label("Delete this book", systemImage: "trash")
                }
            }
        
        Spacer()
        
        Button("Delete")
        {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            {
                success, error in if(success)
                {
                    print("Notifications enabled")
                }
                else if let error = error
                {
                    print(error.localizedDescription)
                }
            }
            
            let notification = UNMutableNotificationContent()
            notification.title = "Book was deleted"
            notification.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            
            showingDeleteAlert = true
        }
        .padding(30)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(.red)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false), value: animationAmount
                            )
        ).onAppear
            {
                animationAmount = 2
            }
        
        Spacer()
    }

    func deleteBook()
    {
        moc.delete(book)

        try? moc.save()
        dismiss()
    }
}
