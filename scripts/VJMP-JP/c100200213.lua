--ボティス
--
--Script by Trishula9
function c100200213.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c100200213.thtg)
	e1:SetOperation(c100200213.thop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c100200213.regcon)
	e2:SetOperation(c100200213.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100200213.seqcon)
	e3:SetTarget(c100200213.seqtg)
	e3:SetOperation(c100200213.seqop)
	c:RegisterEffect(e3)
end
function c100200213.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.IsPlayerCanRemove(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c100200213.rmfilter(c,g)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and g:IsExists(c100200213.thfilter,1,c,c:GetCode())
end
function c100200213.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c100200213.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local sg=g:Filter(c100200213.rmfilter,nil,dg)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100200213,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=dg:FilterSelect(tp,c100200213.thfilter,1,1,rc,rc:GetCode())
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end
function c100200213.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function c100200213.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(100200213,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c100200213.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(100200213)>0
end
function c100200213.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
end
function c100200213.seqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,tp,3)
end
