--閃刀機関－マルチロール
--Brandish Mechanism Multi-Roll
--Script by nekrozar
function c100408038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100408038,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100408038.tgtg)
	e2:SetOperation(c100408038.tgop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100408038,1))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c100408038.settg)
	e3:SetOperation(c100408038.setop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabelObject(e3)
	e4:SetOperation(c100408038.regop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAIN_NEGATED)
	e5:SetOperation(c100408038.regop2)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e6:SetOperation(c100408038.clearop)
	c:RegisterEffect(e6)
end
function c100408038.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c100408038.tgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c100408038.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.BreakEffect()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c100408038.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) then
		Duel.SetChainLimit(c100408038.chainlm)
	end
end
function c100408038.chainlm(e,rp,tp)
	return tp==rp
end
function c100408038.regop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x215) and re:IsActiveType(TYPE_SPELL) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local val=e:GetLabelObject():GetLabel()
		e:GetLabelObject():SetLabel(val+1)
	end
end
function c100408038.regop2(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x215) and re:IsActiveType(TYPE_SPELL) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local val=e:GetLabelObject():GetLabel()
		if val==0 then val=1 end
		e:GetLabelObject():SetLabel(val-1)
	end
end
function c100408038.clearop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function c100408038.setfilter(c)
	return c:IsSetCard(0x215) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c100408038.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c100408038.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c100408038.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100408038.setfilter),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 then return end
	local field=false
	if g:IsExists(Card.IsType,1,nil,TYPE_FIELD) then field=true end
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct>ft then ct=ft end
	if ct<=0 and not field then return end
	local tg=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		tg:Merge(sg)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		if sg:GetFirst():IsType(TYPE_FIELD) then
			field=false
		else
			ct=ct-1
		end
	until (ct==0 and not field) or g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(100408038,1))
	local tc=tg:GetFirst()
	while tc do
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+0x47e0000)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
	Duel.ConfirmCards(1-tp,tg)
end
