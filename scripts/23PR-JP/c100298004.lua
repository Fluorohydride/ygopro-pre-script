--纲引犬会
--Script by 奥克斯
function c100298004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c100298004.drcon)
	e2:SetCost(c100298004.drcost)
	e2:SetTarget(c100298004.drtg)
	e2:SetOperation(c100298004.drop)
	c:RegisterEffect(e2)
	--loss lp
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CUSTOM+100298004)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c100298004.lptg)
	e4:SetOperation(c100298004.lpop)
	c:RegisterEffect(e4)
end
function c100298004.drcon(e,tp,eg,ep,ev,re,r,rp)
	return  r==REASON_RULE 
end
function c100298004.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c100298004.tdfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_TUNER)
end
function c100298004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c100298004.tdfilter,1,nil)
	local tunp=Duel.GetTurnPlayer()
	if chk==0 then return e:GetLabel()==100 and #tg>0 and Duel.IsPlayerCanDraw(tunp,2) end
	e:SetLabel(0)
	local tc=tg:GetFirst()
	if #tg>1 then
		Duel.Hint(HINT_SELECTMSG,tunp,HINTMSG_CONFIRM)
		tc=tg:Select(tunp,1,1,nil):GetFirst()
	end
	Duel.ConfirmCards(1-tunp,tc)
	Duel.ShuffleHand(tunp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tunp,2)
end
function c100298004.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local tunp=Duel.GetTurnPlayer()
	if Duel.Draw(tunp,2,REASON_EFFECT)>0 and tunp~=tp then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+100298004,e,0,tp,0,0)
	end
end
function c100298004.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
end
function c100298004.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-2000)
	if Duel.GetLP(tp)<lp and c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end