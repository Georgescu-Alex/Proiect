//
//  AddBookView.swift
//  Proiect
//
//  Created by m1 on 07/07/2022.
//

import SwiftUI

struct AddBookView: View
{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 2
    @State private var genre = ""
    @State private var desc = ""
    
    let genres = ["Fantasy", "Fiction", "Romance", "Mystery", "Action", "Drama"]
    
    @State private var isShowing = 1
    
    var body: some View
    {
        if isShowing != 0
        {
            NavigationView
            {
                Form
                {
                    Section
                    {
                        TextField("Book Name", text: $title)
                        TextField("Author Name", text: $author)

                        Picker("Genre", selection: $genre)
                        {
                            ForEach(genres, id: \.self)
                            {
                                Text($0)
                            }
                        }
                    }
                    Section
                    {
                        TextEditor(text: $desc)
                        RatingView(rating: $rating)
                    }
                        header:
                        {
                            Text("Description")
                        }
                    Section(
                        footer:
                            HStack
                                {
                                    Spacer()
                                    Button("Save")
                                       {
                                           let newBook = Book(context: moc)
                                           newBook.id = UUID()
                                           newBook.title = title
                                           newBook.author = author
                                           newBook.rating = Int16(rating)
                                           newBook.desc = desc
                                           newBook.genre = genre

                                           try? moc.save()
                                           withAnimation { isShowing = 0 }
                                       }
                                       .padding(40)
                                       .background(.green)
                                       .foregroundColor(.white)
                                       .clipShape(Circle())
                                    Spacer()
                                }
                            )
                            {}
                }.navigationTitle("Add Book")
            }
        }
        else
        {
            NavigationView
            {
                Circle()
                .fill(.green)
                .frame(width: 1000, height: 1000)
            }.onAppear
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                    {dismiss()}
                }
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
