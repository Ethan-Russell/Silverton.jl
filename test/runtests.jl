using Silverton, Test

@testset "Test Silverton" begin
    game = SilvertonGame()
    io = open("test.txt")
    for i in 1:23
        @test redirect_stdin(()->(advance!(game) != π), io)
    end
end