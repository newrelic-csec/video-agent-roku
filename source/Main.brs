'NR Video Agent Example - Main'

sub Main(aa as Object)
    print "Main arg = ", aa
    
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    
    scene = screen.CreateScene("VideoScene")
    screen.show()
    
    'Init New Relic Agent
    m.nr = NewRelic("1567277", "4SxMEHFjPjZ-M7Do8Tt_M0YaTqwf4dTl", true)
    nrAppStarted(m.nr, aa)
    nrSendSystemEvent(m.nr, "TEST_ACTION")
    
    print "Main m = ", m
    
    'Pass NewRelicAgent object to scene
    scene.setField("nr", m.nr)
    'Observe scene field "moreButton" to capture "back" button and abort the execution
    scene.observeField("moteButton", m.port)
    
    'Activate system tracking
    m.syslog = NewRelicSystemStart(m.nr, m.port)
    
    searchTask("hello")
    
    while(true)
        msg = wait(0, m.port)
        print "Msg = ", msg
        
        if nrProcessMessage(m.nr, msg) = false
            'Is not a system message captured by New Relic Agent
            if msg.getField() = "moteButton"
                print "moteButton, data = ", msg.getData()
                if msg.getData() = "back" 
                    exit while
                end if
                if msg.getData() = "OK"
                    'force crash
                    print "Crash!"
                    anyshit()
                end if
            end if
        end if
    end while
end sub

'Test task to show how to generate http events
function searchTask(search as String)
    task = createObject("roSGNode", "SearchTask")
    task.setField("nr", m.nr)
    task.setField("searchString", search)
    task.control = "RUN"
end function
