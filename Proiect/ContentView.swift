//
//  ContentView.swift
//  Proiect
//
//  Created by m1 on 07/07/2022.
//

import SwiftUI

extension View
{
    @ViewBuilder func phoneNavigationView() -> some View
    {
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.navigationViewStyle(.stack)
        }
        else
        {
            self
        }
    }
}

struct ContentView: View
{
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors:[
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    @State private var searchBook = ""
    
    var body: some View
    {
        NavigationView
        {
            List()
            {
                ForEach(books)
                {
                    book in NavigationLink
                    {
                        DetailView(book: book)
                    }label:
                            {
                                HStack
                                {
                                    NumberRatingView(rating: book.rating)
                                        .font(.largeTitle)
                                    
                                    VStack(alignment: .leading)
                                    {
                                        Text(book.title ?? "Unknown Title")
                                            .font(.headline)

                                        Text(book.author ?? "Unknown Author")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                }.onDelete(perform: deleteBooks)
            }
            .searchable(text: $searchBook, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .onChange(of: searchBook)
                {
                    newValue in books.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS %@", newValue)
                }
            .navigationTitle("Books")
            .toolbar
                {
                    ToolbarItem(placement: .navigationBarLeading)
                    {
                        EditButton()
                    }

                    ToolbarItem(placement: .navigationBarTrailing)
                    {
                        Button
                        {
                            showingAddScreen.toggle()
                        }label:
                            {
                                Label("Add Book", systemImage: "plus")
                            }
                    }
                }.sheet(isPresented: $showingAddScreen)
                    {
                        AddBookView()
                    }
        }.phoneNavigationView()
    }

    func deleteBooks(at offsets: IndexSet)
    {
        for offset in offsets
        {
            let book = books[offset]
            moc.delete(book)
        }

        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
